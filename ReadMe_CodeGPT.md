# 功能介绍
对应代码上屏功能，用于在一些不方便切屏和复制粘贴的情景下，使用输入法调用GPT。如下图：
![rime_gpt_code](https://github.com/user-attachments/assets/470b1c6b-8aa7-42fd-82c5-799e02a24914)


操作方式：输入需求“二分查找”（拼音）→输入分隔符‘→输入功能标示字符vai→确认需求→按下alt→等待结果。
# rime-lua配置
对应lua源码文件为`commit_gpt.lua`
填入相关api

在custom_phrase.txt末尾添加`pyc	vai 	9`
重新部署。




