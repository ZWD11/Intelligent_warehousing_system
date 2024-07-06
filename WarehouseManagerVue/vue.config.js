module.exports = {
    devServer: {
      open: true, //配置自动启动浏览器
      host: "localhost",
      port: 9132,
    },
    lintOnSave: false,
    chainWebpack: config => {
      config.module
        .rule('js')
        .include
          .add(/node_modules[\\/]marked/)
          .end()
        .use('babel-loader')
          .loader('babel-loader')
          .tap(options => {
            return {
              ...options,
              plugins: ['@babel/plugin-proposal-class-properties']
            };
          });
    }
  };