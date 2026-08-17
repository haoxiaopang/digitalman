
<div align="center">
    <br>
    <img src="readme/icon.png" alt="Fay">
    <h1>FAY</h1>
	<h3>Fay数字人框架</h3>
</div>

！！重要通知：我们已经把Fay的三个版本合并成1个，并致力提供更稳定更全面的功能。

我们致力于思考面向终端的数字人落地应用，并通过完整代码把思考结果呈现给大家。Fay数字人框架，向上适配各种数字人模型技术，向下接入各式大语言模型，并且便于更换诸如TTS、ASR等模型，为单片机、app、网站提供全面的数字人应用接口。      
更新日志：https://qqk9ntwbcit.feishu.cn/wiki/UlbZwfAXgiKSquk52AkcibhHngg
文档：https://qqk9ntwbcit.feishu.cn/wiki/JzMJw7AghiO8eHktMwlcxznenIg


## **功能特点**



- 完全开源，商用免责
- 支持全离线使用
- 全时流式的支持
- 自由匹配数字人模型、大语言模型（openai 兼容接口）、ASR、TTS模型
- 支持数字人自动播报模式（虚拟教师、虚拟主播、新闻播报）
- 支持任意终端使用：单片机、app、网站、大屏、三方业务系统接入等
- 支持多用户多路并发
- 提供文字交互接口、语音交互接口、数字人驱动接口、管理控制接口、自动播报接口、意图接口
- 支持语音指令灵活配置执行（qa.csv）
- 支持自定义知识库、自定义问答对、自定义人设信息
- 支持唤醒及打断对话
- 支持服务器及单机模式
- 支持机器人表情输出
- 支持agent自主决策工具调用
- 基于日程式数字人主动对话
- 支持后台静默启动
- 支持deepseek等thinking llm
- 自我认知提高
- 仿生记忆
- 支持MCP工具管理（sse、studio）
- 提供配置管理中心
- 全链路交互互通

###               

## **Fay数字人框架**

![](readme/chat.png)

![](readme/controller.png)

![](readme/mcp.png)






## **源码启动**


### **环境** 
- Python 3.12

- Windows、macos、ubuntu

- 注：ubuntu需要先安装gcc及portaudio

- ````bash
  sudo apt update
  sudo apt install build-essential
  sudo apt install portaudio19-dev
  ````

  

### **安装依赖**

```shell
pip install -r requirements.txt
```


### **快速启动**
本地
```shell
python main.py start -config_center d19f7b0a-2b8a-4503-8c0d-1a587b90eb69  #使用公共资源，速度非常慢，建议更换成自己的key
```
镜像
```shell
https://www.compshare.cn/images/compshareImage-1cft3sk9gvta?ytag=GPU_fay
```

### **Docker Compose 部署（Fay + 配置中心 + Mate Human）**

项目根目录的 `docker-compose.yml` 会启动三个服务：Fay 后端、[fay_config_server](https://github.com/xszyou/fay_config_server) 配置中心和 [mate-human](https://gitee.com/garveyer/mate-human) Live2D 前端。首次构建需要访问 Docker 镜像仓库、代码仓库和 npm/PyPI 软件源。

#### 环境要求

- Docker Engine
- Docker Compose v2，确认命令为 `docker compose version`
- 在 Fay 项目根目录执行命令
- 主机端口 `5000`、`5010`、`5173`、`5500`、`10001`、`10002`、`10003` 未被其他程序占用

#### 首次启动

1. 创建环境变量文件：

```shell
cp .env.example .env
```

2. 编辑 `.env`。至少应修改配置中心 API key 和 session 密钥；`FAY_CONFIG_CENTER_ID` 首次可以留空：

```dotenv
FAY_CONFIG_CENTER_ID=
FAY_CONFIG_CENTER_API_KEY=请替换为本地随机密钥
FAY_CONFIG_CENTER_SECRET_KEY=请替换为本地随机长字符串
FAY_CONFIG_CENTER_URL=http://fay-config-server:5500
```

`FAY_CONFIG_CENTER_URL` 是容器内部地址，必须使用 `fay-config-server`，不要在这里填写 `127.0.0.1` 或 `localhost`。

3. 启动前检查 Compose 配置：

```shell
docker compose config
```

4. 构建并启动三个服务：

```shell
docker compose up -d --build
```

5. 查看服务状态和日志：

```shell
docker compose ps
docker compose logs -f fay fay-config-server mate-human
```

#### 服务地址

| 服务 | 地址 | 用途 |
| --- | --- | --- |
| Fay | `http://127.0.0.1:5000` | Web 管理页、HTTP API 和音频文件 |
| Fay MCP | `http://127.0.0.1:5010/Page3` | MCP 管理页 |
| Fay WebSocket | `ws://127.0.0.1:10002` | Mate Human 接收音频、口型和动作消息 |
| Fay UI WebSocket | `ws://127.0.0.1:10003` | Fay Web 管理界面通信 |
| 配置中心 | `http://127.0.0.1:5500` | 管理 `system.conf` 和 `config.json` |
| Mate Human | `http://127.0.0.1:5173` | Live2D 数字人前端 |

#### 配置中心初始化

首次打开 `http://127.0.0.1:5500`，使用默认本地账号登录：

```text
用户名：admin
密码：admin
```

默认账号只适合本机测试，不要直接将 `5500` 暴露到公网。创建项目时，项目路径填写配置中心容器内的路径：

```text
/source/fay
```

保存项目后，从浏览器地址 `/project/<项目UUID>/config` 中复制项目 UUID，写入 `.env`：

```dotenv
FAY_CONFIG_CENTER_ID=<项目UUID>
```

然后仅重启 Fay：

```shell
docker compose up -d fay
```

Fay 会通过 Compose 内部网络访问配置中心，并优先加载该项目配置。配置中心数据保存在 Docker 命名卷 `fay_config_projects` 中；修改配置中心内容后需要重新加载 Fay：

```shell
docker compose restart fay
```

如果 `FAY_CONFIG_CENTER_ID` 留空，Fay 使用项目根目录的本地 `system.conf` 和 `config.json`。

#### 按服务更新和停止

只修改了 Fay 代码或 [Dockerfile](Dockerfile) 时：

```shell
docker compose up -d --build fay
```

只修改了 Mate Human 前端时：

```shell
docker compose up -d --build mate-human
```

仅修改配置文件时，不需要构建镜像：

```shell
docker compose restart fay
```

停止服务但保留配置中心数据：

```shell
docker compose down
```

不要随意使用 `docker compose down -v`，该命令会删除 `fay_config_projects`，导致配置中心创建的项目和配置数据丢失。

#### 运行注意事项

- Mate Human 是浏览器端前端，源码使用 `ws://127.0.0.1:10002` 和 `http://127.0.0.1:5000/audio/...`。在 Docker 主机本机浏览器中访问 `5173` 时可直接工作；远程浏览器访问时，需要将前端中的 `127.0.0.1` 改为 Fay 主机地址，或配置反向代理。
- 浏览器首次播放 Fay 语音可能触发自动播放限制。进入 Mate Human 页面后先点击一次页面或 `Enable Audio` 解锁按钮，再进行对话。
- Linux Docker 无法运行 Windows 专用的 `ProcessWAV.exe`。当前 Fay 在 Linux 中使用音频能量生成近似 `Lips` 数据；修改相关代码后必须重新构建 Fay 镜像，单纯 `restart` 不会更新镜像代码。
- 如果端口冲突，修改 Compose 中左侧的宿主机端口，例如将 `5173:80` 改为 `5174:80`，然后用新的地址访问。
- `.env` 包含 API key 和密钥，已被 Git 忽略，不要提交到仓库。

### **个性化配置**
+ 根目录system.conf.bak 重命名为system.conf，并配置里面的内容

### **管理页面**
+ 浏览器访问 http://127.0.0.1:5000
+ MCP 管理页面访问 http://127.0.0.1:5010/Page3

## **高级玩法**

![](readme/interface.png)



### ***使用数字人（非必须）***
https://qqk9ntwbcit.feishu.cn/wiki/GHevwqxwfiX4hCk8yJCcoJ54nqg




### ***集成到自家产品（非必须）***
https://qqk9ntwbcit.feishu.cn/wiki/Mcw3wbA3RiNZzwkexz6cnKCsnhh


## **致谢**

感谢以下开源项目为 Fay 提供的技术支持：

- [openclaw](https://github.com/openclaw/openclaw) - 提供记忆机制及skills设计的参考
- [OpenAI Codex](https://github.com/openai/codex) - 提供稳定的工具调用能力的参考
- [FunASR](https://github.com/modelscope/FunASR) - 提供语音识别（ASR）能力
