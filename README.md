# kcptun-starter

## Quick start
1. Clone
```
cd /opt/
git clone git@github.com:pptom/kcptun-starter.git
```

2. Config

```
{
	"listen": ":29900",
	"target": "ip:port",
	"key": "yourpassword",
	"crypt": "salsa20",
	"mode": "manual",
	"mtu": 1400,
	"sndwnd": 1024,
	"rcvwnd": 1024,
	"datashard": 30,
	"parityshard": 15,
	"dscp": 46,
	"nocomp": true,
	"acknodelay": false,
	"nodelay": 0,
	"interval": 20,
	"resend": 2,
	"nc": 1,
	"sockbuf": 4194304,
	"keepalive": 10,
	"log": "/opt/kcptun-starter/kcptun.log"
}
```

3. Start 
```
chmod +x 
./kcptun-starter.sh start 
```

4. Usage
```
Usage: /opt/kcptun-starter/kcptun-starter.sh {start|stop|restart|status|log}
```
