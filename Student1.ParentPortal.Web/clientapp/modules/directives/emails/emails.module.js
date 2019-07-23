angular.module('app')
    .component('emails', {
        bindings: {
            model: '=', // One way data binding. ( '=' Two way binding, '@' Textual binding, '&' Function/Callback binding)
            form: '<'
        }, 
        templateUrl: 'clientapp/modules/directives/emails/emails.view.html',
        controllerAs: 'ctrl',
        controller: ['api', function (api) {
            var ctrl = this;

            // Load types
            api.types.getElectronicMailTypes().then(function (types) {
                ctrl.electronicMailTypes = types;
            });

            ctrl.delete = function (index) { ctrl.model.splice(index, 1); };

            ctrl.add = function () {
                var template = { electronicMailAddress: null, electronicMailTypeId: 1, primaryEmailAddressIndicator: null };
                ctrl.model.push(template);
            };

            ctrl.choosePrimaryMail = function (mail) {
                ctrl.model.forEach(function (mail) { mail.primaryEmailAddressIndicator = false; });
                mail.primaryEmailAddressIndicator = true;
            }

        }]
    });