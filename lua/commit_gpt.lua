-- commit_gpt.lua
function extract_code(markdown_text)
    -- 查找 ```python 的位置
    local start_tag = "```python"
    local start_pos = string.find(markdown_text, start_tag)
    if not start_pos then
        return markdown_text -- 如果没有找到代码块，返回原字符串
    end

    -- 查找 ``` 结束标记的位置
    local end_tag = "```"
    local end_pos = string.find(markdown_text, end_tag, start_pos + #start_tag)
    if not end_pos then
        return markdown_text -- 如果没有找到结束标记，返回原字符串
    end

    -- 提取代码部分
    local code_start = start_pos + #start_tag
    local code_end = end_pos - 1
    local code = string.sub(markdown_text, code_start, code_end)

    -- 去除首尾空白字符
    code = string.gsub(code, "^%s*(.-)%s*$", "%1")
    -- log_message("committed_text: " .. code)

    return code
end

local function gpt_generate(content, role_content)
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local cjson = require("cjson")
    local url = "https://ark.cn-beijing.volces.com/api/v3/chat/completions"
    local api_key = "" -- 替换为你的 API Key

    -- 构建请求数据
    local request_data = {
        model = "doubao",
        messages = {
            {role = "system", content = role_content},
            {role = "user", content = content}
        }
    }
    local request_body = cjson.encode(request_data)
    local response_body = {}
    -- 发送 HTTP 请求
    -- log_message("success1")
    local res, code, response_headers, status = http.request {
        url = url,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. api_key,
            ["Content-Length"] = tostring(#request_body)
        },
        source = ltn12.source.string(request_body),
        sink = ltn12.sink.table(response_body)
    }
    -- 解析响应数据
    local response_table = cjson.decode(table.concat(response_body))
    gpt_out = extract_code(response_table.choices[1].message.content)
    -- log_message("success1" .. gpt_out)
    return gpt_out
end


local function ensure_newline_at_end(str)
    -- 检查字符串是否包含 \r 或 \n
    local has_newline = string.find(str, "[\r\n]") ~= nil

    -- 如果字符串包含 \r 或 \n，且末尾没有 \n，则在末尾添加 \n
    if has_newline and not string.match(str, "\n$") then
        str = "# python\n" .. str .. "\n\n"
    end

    return str
end

local function commit_gpt(key, env)
    local context = env.engine.context
    if context:has_menu() then
        -- log_message(key:repr())
        if key:repr() == "Release+Alt_R" then
            -- Get the committed candidate text
            local committed_text = context:get_commit_text()
            fuc_code = string.sub(committed_text, -3)
            if fuc_code == "pyc" then
                local output = string.sub(committed_text, 1, -4)
                local role =
                    "你是一个高级软件工程师。我会发送给你编程需求，你需要按要求完成python代码。注意，你只需要发送给我代码文件，不用输出其他备注信息。"
                local gpt_content = gpt_generate(output, role)

                env.engine:commit_text(ensure_newline_at_end(gpt_content))

                context:clear()
                return 1

            end
        end
    end

    -- Return kNoop to pass through other keys
    return 2 -- kNoop
end

return commit_gpt
