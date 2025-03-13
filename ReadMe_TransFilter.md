对应双引号翻译候选框的功能，如下图。
![rime_translate](https://github.com/user-attachments/assets/4d7d8133-76bf-4871-a1f2-8dfe18602b4a)


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
