angular.module('app')
    .filter('recipient', function () {
        return function (recipients, value) {

            if (!value)
                return recipients;

            var out = [];

            out = recipients.filter(function (r) {
                return r.fullName.toUpperCase().includes(value.toUpperCase());
            });
            return out;
        }
    });