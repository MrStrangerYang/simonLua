local function niu_translate(sentence, src_lan, tgt_lan)
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local cjson = require("cjson")
    local url = "http://api.niutrans.com/NiuTransServer/translationArray"
    local request_data = {
        from = src_lan,
        to = tgt_lan,
        apikey = "你的API",
        src_text = sentence
    }
    local request_body = cjson.encode(request_data)

    local response_body = {}

    local res, code, response_headers, status = http.request {
        url = url,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#request_body)
        },
        source = ltn12.source.string(request_body),
        sink = ltn12.sink.table(response_body)
    }
    local response_table = cjson.decode(table.concat(response_body))
    return response_table.tgt_list
  end

local function is_chinese_character(char)
    local code = utf8.codepoint(char)
    return code >= 0x4E00 and code <= 0x9FFF
end

local function filter(input, env)
    local input_text = env.engine.context.input

    if input_text:sub(-2) == "''" then
        local raw_input = {}
        local count = 0
        for cand in input:iter() do
            local first_char = utf8.char(utf8.codepoint(cand.text))
            if is_chinese_character(first_char) then
                if count < 6 then
                    count = count + 1
                    table.insert(raw_input, cand.text)
                else
                    break
                end
            end
        end
        local trans = niu_translate(raw_input, 'auto', 'en')
        for i, v in ipairs(trans) do
            yield(Candidate("date", 0, 20, v.tgt_text, raw_input[i]))
        end
    else
        for cand in input:iter() do
            yield(cand)
        end
    end
end

return filter
