# 一、安装rime
## Windows安装
小狼毫+雾凇方案，安装教程参考这篇博文[^1]。

⚠️ 使用小狼毫自带的配置文件安装工具需要先安装Git[^2]。
## Mac安装
安装使用rime-auto-deploy[^3]。

# 二、安装必要的lua包
## 安装lua、luarocks、luasocket
### Windows上lua环境配置要麻烦些
1. Windows安装scoop[^5]
2. 使用scoop安装lua `scoop install main/lua`
3. 使用scoop安装luarocks `scoop install main/luarocks`
4. 使用 visual studio 的命令行测试安装luasocket。这一步参考windows 基本环境搭建教程[^4]
5. 为了方便管理，在x 64 Native Tools Command Prompt for VS 2022 命令行中，将luasocket安装到自定义路径，比如 `luarocks install lua-socket --tree= C:\Users\yourname\lua\luarocks`
6. 将自定义路径添加到环境变量[^4]
### Mac上直接brew安装lua、luarocks
LuaRocks 安装的包，默认放在 /opt/homebrew/share/lua 路径下，不能被rime索引。
建议将lua包安装到 `/usr/local`
```bash
luarocks install lua-socket --tree=/usr/local/
luarocks install lua-cjson --tree=/usr/local/
```

# 三、配置Rime-lua
下载 `niu_trans_filter.lua` 放到lua文件内
Rime文件夹结构如下
```
- lua ##文件夹
	-- niu_trans_filter.lua
- rime_ice.custom.yaml
```
代码 `niu_trans_filter.lua` 目前是小牛翻译，api请到官网申请。
在你的输入法方案中，添加filter，比如我的是 `rime_ice.custom.yaml`。
```
punch:
	engine/filters/+:
    	- lua_translator@*niu_trans_filter
```
之后重新部署就ok了。
# 注解：调试rime-lua
## 添加调试脚本
把 `rime.lua` 放到根目录下面
```lua
-- rime.lua
-- Define a global variable for the log file path
local log_file_path = "D:/Code/log/file.log"
-- Function to log messages
function log_message(message)
    local file = io.open(log_file_path, "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n")
        file:close()
    else
        print("Failed to open log file: " .. log_file_path)
    end
end
-- Example usage: log a message
log_message("Rime Lua script initialized.")
```
**重新部署** rime，可以看到在 `file.log` 当中的输入
>  2025-03-12 02:48:46 - Rime Lua script initialized.
## 设置“调试断点”
```lua
local function filter(input, env)
    local input_text = env.engine.context.input
    -- Example usage:设置一个观察点，看是否触发了filter
    log_message("Rime Lua script: niutranslate filter.")
```
## 捕获lua异常
因为我们使用了第三方的包模块，可能不会被rime-lua加载。可以使用如下示例代码来捕获类似错误。
```lua
local success, err = pcall(function()
    local http = require("socket.http")
    end)
    if not success then
        log_message("加载模块失败，错误信息为：" .. err)
    end
```
Log输出如下：
>  2025-03-12 02:48:53 - 加载模块失败，错误信息为：...sers\pigge\AppData\Roaming\Rime\lua\niu_trans_filter.lua:3: module 'socket.http' not found:
> 	no field package.preload['socket.http']
> 	no file 'C:\Users\pigge\AppData\Roaming\Rime\lua\socket\http.lua'
> 	no file 'C:\Users\pigge\AppData\Roaming\Rime\lua\socket\http\init.lua'
> 	no file 'C:\Program Files\Rime\weasel-0.16.3\data\lua\socket\http.lua'

解决方法参考Section 2 


# 参考资料

[^1]: [RIME + 雾凇拼音，打造绝佳的开源文字输入体验 - 少数派](https://sspai.com/post/89281)

[^2]: [Git - 安装 Git](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git)

[^3]: [GitHub - Mark24Code/rime-auto-deploy: Rime输入法安装脚本，让一切更轻松。Make using Rime easy.](https://github.com/Mark24Code/rime-auto-deploy?tab=readme-ov-file)

[^4]: [lua 开发环境搭建 - 潼关路边的一只野鬼 - 博客园](https://www.cnblogs.com/bibleghost/p/18225523)

[^5]: [Scoop](https://scoop.sh/#/)
