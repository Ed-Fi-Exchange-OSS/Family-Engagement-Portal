angular.module('app')
    .filter('bold', function ($sce) {
        return function (name, query) {
            if (!query)
                return name;

            var queryTerms = query.split(' ');
            queryTerms.forEach(function (qt) {
                name = name.replace(new RegExp(qt, 'gi'), m => { return '<b>' + m + '</b>' });
            });
            return $sce.trustAsHtml(name);
    }
});