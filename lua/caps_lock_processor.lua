-- 定义模块
local caps_lock_processor = {}

-- 初始化函数
function caps_lock_processor.init(env)
  -- 初始化 CapsLock
  env.caps_lock_on = false
end

-- 处理按键事件的函数
function caps_lock_processor.func(key, env)
  -- 获取按键的键
  local keycode = key.keycode
  -- log_message("input: " .. key:repr())
  if key:repr() == "Lock+Caps_Lock" then
    -- 获取当前输入的编码
    local input_code = env.engine.context.input

    --
    if input_code ~= "" then
      -- log_message("input: " .. input_code)

      env.engine:commit_text(input_code)
      env.engine.context:clear() -- 清空当前输入
      -- local input_code = env.engine.context.input
      -- log_message("input2: " .. input_code)
    end

    -- 切换 ascii_mode
    env.engine.context:set_option("ascii_mode", true)

    -- 返回 kAccepted，表示按键事件已被处理
    return 1
  end

  if key:repr() == "Release+Caps_Lock" then
    local input_code = env.engine.context.input

    --
    if input_code ~= "" then
      -- log_message("input: " .. input_code)

      env.engine:commit_text(input_code)
      env.engine.context:clear() -- 清空当前输入
      -- local input_code = env.engine.context.input
      -- log_message("input2: " .. input_code)
    end

    -- 切换 ascii_mode
    env.engine.context:set_option("ascii_mode", false)

    -- 返回 kAccepted，表示按键事件已被处理
    return 1
  end

  if string.find(key:repr(), "^Lock%+Release%+Shift") then
    -- 切换 ascii_mode
    -- log_message("捕获: shift" .. key:repr())
    env.engine.context:set_option("ascii_mode", true)

    -- 返回 kAccepted，表示按键事件已被处理
    return 1
  end

  -- 返回 kNoop，表示按键事件未被处理
  return 2

end

-- 返回模块
return caps_lock_processor
