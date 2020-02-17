--region dependency: immune_http_1_0_0
--region ffi
local ffi = require("ffi")

ffi.cdef[[
    typedef uint32_t request_handle_t;
    typedef uint64_t steam_api_call_t;

    typedef struct {
        void* __pad[11];
        void* steam_http;
	}steam_ctx_t;

    typedef uint32_t(__thiscall* create_http_request_t)(void*, uint32_t, const char*);
    typedef bool(__thiscall* send_http_request_t)(void* _this, request_handle_t handle, steam_api_call_t call_handle);
    typedef bool(__thiscall* get_http_response_header_size_t)( void* _this, request_handle_t hRequest, const char *pchHeaderName, uint32_t *unResponseHeaderSize );
    typedef bool(__thiscall* get_http_response_header_value_t)(void* _this, request_handle_t hRequest, const char *pchHeaderName, char *pHeaderValueBuffer, uint32_t unBufferSize);
    typedef bool(__thiscall* get_http_response_body_size_t)(void* _this, request_handle_t hRequest, uint32_t *unBodySize );
    typedef bool(__thiscall* get_http_response_body_data_t)(void* _this, request_handle_t hRequest, char *pBodyDataBuf, uint32_t unBufferSize );
    typedef bool(__thiscall* set_http_request_param_t)(void* _this, request_handle_t hRequest, const char* pchParamName, const char* pchParamValue);
    typedef bool(__thiscall* release_http_request_t)(void* _this, request_handle_t hRequest);
]]

local steam_ctx_match = client.find_signature("client_panorama.dll", "\xFF\x15\xCC\xCC\xCC\xCC\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x6A") or error("steam_ctx")
local steam_ctx = ffi.cast("steam_ctx_t**", ffi.cast("char*", steam_ctx_match) + 7)[0] or error("steam_ctx not found")

local steam_http = ffi.cast("void*", steam_ctx.steam_http) or error("steam_http error")
local steam_http_ptr = ffi.cast("void***", steam_http) or error("steam_http_ptr error")
local steam_http_vtable = steam_http_ptr[0] or error("steam_http_ptr was null")

local create_http_request = ffi.cast('create_http_request_t', steam_http_vtable[0])
local send_http_request = ffi.cast('send_http_request_t', steam_http_vtable[5])
local get_http_response_header_size = ffi.cast('get_http_response_header_size_t', steam_http_vtable[9])
local get_http_response_header_value = ffi.cast('get_http_response_header_value_t', steam_http_vtable[10])
local get_http_response_body_size = ffi.cast('get_http_response_body_size_t', steam_http_vtable[11])
local get_http_response_body_data = ffi.cast('get_http_response_body_data_t', steam_http_vtable[12])
local set_http_request_param = ffi.cast('set_http_request_param_t', steam_http_vtable[4])
local release_http_request = ffi.cast('release_http_request_t', steam_http_vtable[14])
--endregion

--region request
local request_c = {}
local request_mt = {__index = request_c}

--- Instantiate a request object.
function request_c.new(handle, url, callback)
	local properties = {
		handle = handle,
		url = url,
		callback = callback,
		ticks = 0
	}

	local request = setmetatable(properties, request_mt)

	return request
end
--endregion

--region response
local response_c = {}
local response_mt = {__index = response_c}

--- Instantiate a response object.
function response_c.new(state, body, headers)
	local properties = {
		state = state,
		body = body,
		header = {
			content_type = headers.content_type
		}
	}

	local response = setmetatable(properties, response_mt)

	return response
end

--- Returns true if the response is good. False if not.
function response_c:success()
	return self.state == 0
end
--endregion

--region http
local http_c = {
	state = {
		ok = 0,
		no_response = 1,
		timed_out = 2,
		unknown = 3
	}
}
local http_mt = {__index = http_c}

--- Instantiate an http object.
function http_c.new(options)
	local options = options or {}

	local properties = {
		requests = {},
		task_interval = options.task_interval or 0.5,
		enable_debug = options.debug or false,
		timeout = options.timeout or 10
	}

	local http = setmetatable(properties, http_mt)

	-- Initiate task queue processing.
	http:_process_tasks()

	return http
end

--- HTTP add get request to queue.
function http_c:get(url, callback)
	-- Create an HTTP handle.
	local handle = create_http_request(steam_http, 1, url)

	-- Return if we cannot process the request.
	if (send_http_request(steam_http, handle, 0) == false) then
		return
	end

	-- Create a request object.
	local request = request_c.new(handle, url, callback)

	-- Debug.
	self:_debug("[HTTP] New GET request to: %s", url)

	-- Add the request to the task queue.
	table.insert(self.requests, request)
end

--- HTTP add post request to queue.
function http_c:post(url, params, callback)
	-- Create an HTTP handle.
	local handle = create_http_request(steam_http, 3, url)

	-- Set all POST parameters on handle.
	for k, v in pairs(params) do
		set_http_request_param(steam_http, handle, k, v)
	end

	-- Return if we cannot process the request.
	if send_http_request(steam_http, handle, 0) == false then
		return
	end

	-- Create a request object.
	local request = request_c.new(handle, url, callback)

	-- Debug.
	self:_debug("[HTTP] New POST request to: %s", url)

	-- Add the request to the task queue.
	table.insert(self.requests, request)
end

--- HTTP process task queue.
function http_c:_process_tasks()
	for request_id, request in ipairs(self.requests) do
		-- Request body size FFI.
		local body_size_ptr = ffi.new("uint32_t[1]")

		-- Debug.
		self:_debug("--------------------")
		self:_debug("[HTTP] Processing request #%s", request_id)

		-- Process request.
		if (get_http_response_body_size(steam_http, request.handle, body_size_ptr) == true) then
			-- Set response body size.
			local body_size = body_size_ptr[0]

			-- If a body was gotten from request.
			if body_size > 0 then
				-- Body FFI.
				local body = ffi.new("char[?]", body_size)

				-- Get the response body.
				if (get_http_response_body_data(steam_http, request.handle, body, body_size) == true) then
					-- Debug.
					self:_debug("[HTTP] Request #%s finished. Invoking callback.", request_id)

					-- Remove request from queue.
					table.remove(self.requests, request_id)

					-- Release HTTP request.
					release_http_request(steam_http, request.handle)

					-- Fire the request callback.
					request.callback(response_c.new(
						http_c.state.ok,
						ffi.string(body, body_size),
						{
							content_type = http_c._get_header(request, "Content-Type")
						}
					))
				end
			else
				-- the server's response was empty.
				table.remove(self.requests, request_id)

				-- Release HTTP request.
				release_http_request(steam_http, request.handle)

				-- Fire the request callback.
				request.callback(response_c.new(
					http_c.state.no_response,
					nil,
					{}
				))
			end
		end

		-- Incremented tick count.
		local tick_incremented = request.ticks + 1

		-- Return a timed out response.
		if tick_incremented >= self.timeout then
			-- Remove request from queue.
			table.remove(self.requests, request_id)

			-- Release HTTP request.
			release_http_request(steam_http, request.handle)

			-- Fire the request callback.
			request.callback(response_c.new(
				http_c.state.timed_out,
				nil,
				{}
			))
		else
			-- Increment ticks.
			request.ticks = tick_incremented
		end
	end

	-- Repeat task queue processing.
	client.delay_call(self.task_interval, http_c._bind(self, '_process_tasks'))
end

--- Log debug information to console.
function http_c:_debug(...)
	if (self.enable_debug == true) then
		client.log(string.format(...))
	end
end

--- HTTP get header.
function http_c._get_header(request, header)
	-- Header size FFI.
	local header_size_ptr = ffi.new("uint32_t[1]")

	-- Get the header.
	if (get_http_response_header_size(steam_http, request.handle, header, header_size_ptr)) then
		-- Header size.
		local header_size = header_size_ptr[0]

		-- Header buffer.
		local header_buffer = ffi.new("char[?]", header_size)

		-- Return header.
		if (get_http_response_header_value(steam_http, request.handle, header, header_buffer, header_size)) then
			return ffi.string(header_buffer, header_size)
		end
	end

	-- No header found.
	return nil
end

--- Binds object callbacks.
function http_c._bind(t, k)
	return function(...) return t[k](t, ...) end
end
--endregion
--endregion

return http_c
