# reserve-app

# 1、文件目录

- django后端
    - reserveweb/ 项目名，项目配置文件所在
    - account/ 账号
    - place/ 场地
    - reserve/ 预约
    - content/ 主页内容，包括须知和轮播图
    - static/ 静态文件，webpack打包后静态文件存放至此
    - templates/ html文件，webpack打包后html文件存放至此
    - uploadFile/ 存放上传的图片
- vue前端
    - web/ 前端项目文件夹
        - src/ vue源代码文件夹
        - dist/ webpack打包后的输出文件夹
            - assets/ 资源文件夹
            - common/ 公共js函数文件夹
            - components/ vue组件文件夹
            - pages/ 各页面文件夹
            - plugins/ 插件文件夹
        

# 2、数据库
```
'NAME': 'reserve_web',
'USER': 'root',
'PASSWORD': '123123',
'HOST': '127.0.0.1'
```
settings.py设置数据库
```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'reserve_web',
        'USER': 'root',
        'PASSWORD': '1231123',
        'HOST': '127.0.0.1',
    }
}
```

# 3、项目开发和运行

## 3.1、安装后端项目依赖
```cmd
# 需要安装好python3

pip install PyMySQL
pip install django
pip install django-cors-headers
```

## 3.2、安装前端项目依赖
```
# 需要安装好nodejs

# 切换到前端目录下
cd web
# 安装项目依赖，速度慢的话可用淘宝镜像(cnpm install)
npm install
npm install vue-quill-editor
```
## 3.3、运行项目
```cmd
# 切换到项目根目录

python manage.py runserver
```


## 3.4、开发
* 主要修改web/src下的文件，修改完后，在web目录下运行`npm run build`进行打包生成dist文件夹  
* 开发vue前端，则运行`npm run serve`，它不与后端交互


