angular.module('app.services')
    .service('stateStorage', [function () {

        return {
            setState: function (key, state) {
                localStorage.setItem(key, state);
            },
            getState: function (key) {
                return localStorage.getItem(key);
            },
            removeState: function (key) {
                localStorage.removeItem(key);
            }
        };
    }]);