angular.module("app.config", [])
    .constant("appConfig", {
        api: {
            rootApiUri: "api/",
            key: "",
            secret: ""
        },
        azureAd: {
            instance: "https://login.microsoftonline.com/",
            tenant: "toolwise.onmicrosoft.com",
            clientId: "c34f1634-092c-476e-baa9-29e429717879",
            policy: "B2C_1_FirstTest",
            scope: "openid"
        },
        hero: {
            client: 'YP'
        },
        version: "v1.0.0"
    });