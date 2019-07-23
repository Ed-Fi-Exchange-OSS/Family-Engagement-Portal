angular.module('app')
    .component('telephone', {
        bindings: {
            model: '=', // One way data binding. ( '=' Two way binding, '@' Textual binding, '&' Function/Callback binding)
            form: '<'
        }, 
        templateUrl: 'clientapp/modules/directives/telephone/telephone.view.html',
        controllerAs: 'ctrl',
        controller: ['api', function (api) {
            var ctrl = this;

            // Load types
            api.types.getTelephoneNumberTypes().then(function (types) {
                ctrl.telephoneTypes = types;
            });

            api.types.getTextMessageCarrierTypes().then(function (types) {
                ctrl.textMessageCarrierTypes = types;
            });

            ctrl.delete = function (index) { ctrl.model.splice(index, 1); };

            ctrl.add = function () {
                var template = { telephoneNumber: null, telephoneNumberTypeId: 1, primaryMethodOfContact: null, textMessageCapabilityIndicator:null };
                ctrl.model.push(template);
            };

            ctrl.choosePrimaryeTelephone = function (telephone) {
                ctrl.model.forEach(function (telephone) { telephone.primaryMethodOfContact = false; });
                telephone.primaryMethodOfContact = true;
            }
        }]
    });