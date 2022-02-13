let glob = require('glob')

//配置pages多页面获取当前文件夹下的html和js
function getEntry(globPath) {
    let entries = {},
        tmp, htmls = {};

    // 读取src/pages/**/底下所有的html文件
    glob.sync(globPath + 'html').forEach(function(entry) {
        tmp = entry.split('/').splice(-3);
        htmls[tmp[1]] = entry
    })

    // 读取src/pages/**/底下所有的js文件
    glob.sync(globPath + 'js').forEach(function(entry) {
        tmp = entry.split('/').splice(-3);
        entries[tmp[1]] = {
            entry,
            template: htmls[tmp[1]] ? htmls[tmp[1]] : 'index.html', //  当前目录没有有html则以共用的public/index.html作为模板
            filename: tmp[1] + '.html' //  以文件夹名称.html作为访问地址
        };
    });
    console.log(entries)
    return entries;
}
let htmls = getEntry('./src/pages/**/*.');


module.exports = {
    outputDir: 'dist', // 运行时生成的生产环境构建文件的目录(默认''dist''，构建之前会被清除)
    assetsDir: 'static', //放置生成的静态资源(s、css、img、fonts)的(相对于 outputDir 的)目录(默认'')
    pages: htmls,
    lintOnSave: true, // 是否在保存的时候检查
    productionSourceMap: false, // 生产环境是否生成 sourceMap 文件
    pwa: {
        iconPaths: {
            favicon32: 'favicon.ico',
            favicon16: 'favicon.ico',
            appleTouchIcon: 'favicon.ico',
            maskIcon: 'favicon.ico',
            msTileImage: 'favicon.ico'
        }
    },
    // css: {
    //     extract: true, // 是否使用css分离插件 ExtractTextPlugin
    //     sourceMap: false, // 开启 CSS source maps
    //     loaderOptions: {}, // css预设器配置项
    //     modules: false // 启用 CSS modules for all css / pre-processor files.
    // },
    //反向代理
    // devServer: {
    //   // 环境配置
    //   host: '192.168.1.53',
    //   port: 8080,
    //   https: false,
    //   hotOnly: false,
    //   open: true, //配置自动启动浏览器
    //   proxy: {
    //     // 配置多个代理(配置一个 proxy: 'http://localhost:4000' )
    //     // '/api': {
    //     //   target: 'http://192.168.1.248:9888',
    //     //   // target: 'http://192.168.1.4:8999',
    //     //   pathRewrite: {
    //     //     '^/api': '/api'
    //     //   }
    //     // }
    //   }
    // },
    // pluginOptions: {
    //     // 第三方插件配置
    //     // ...
    // }
}