angular.module('app')
    .filter('bold', function ($sce) {
        return function (text, phrase) {
        if (phrase && phrase.length > 0)
            text = text.replace(new RegExp('(' + phrase + ')', 'gi'), '<mark>$1</mark>');

        return $sce.trustAsHtml(text);
    }
});