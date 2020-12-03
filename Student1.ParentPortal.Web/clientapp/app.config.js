angular.module("app.config", [])
    .constant("appConfig", {
        api: {
            rootUri: "",
            rootApiUri: "api/",
            key: "",
            secret: ""
        },
        hero: {
            client: 'YP'
        },
        version: "v1.0.0"
    });