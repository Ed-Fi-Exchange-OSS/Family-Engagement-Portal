angular.module('app')
    .component('addresses', {
        bindings: {
            model: '<', // One way data binding. ( '=' Two way binding, '@' Textual binding, '&' Function/Callback binding)
            form: '<'
        }, 
        templateUrl: 'clientapp/modules/directives/addresses/addresses.view.html',
        controllerAs: 'ctrl',
        controller: ['api', function (api) {
            var ctrl = this;

            // Load types
            api.types.getAddressTypes().then(function (types) { ctrl.addressTypes = types; });
            api.types.getStateAbbreviationTypes().then(function (types) { ctrl.stateAbbreviationTypes = types; });

            ctrl.delete = function (index) { ctrl.model.splice(index, 1); };

            ctrl.add = function () {
                var template = {
                    streetNumberName: null,
                    apartmentRoomSuiteNumber: null,
                    addressTypeId:1,
                    city: null,
                    stateAbbreviationTypeId: 1,
                    postalCode: null
                };
                ctrl.model.push(template);
            };

        }]
    });