function getPostId(element) {
    window.webkit.messageHandlers.jsMessenger.postMessage(element.getAttribute('data-ml-post-id'));
}

var postLenght = 0;

window.onload = function() {
    let elements = document.getElementsByClassName('list-item');
    for (let item of elements) {
        item.addEventListener('click', function() {
            getPostId(item);
        });
    }
    postLenght = elements.length;
}

var observer = new MutationObserver(function(mutations) {
    let elements = document.getElementsByClassName('list-item');
    let elementsArr = Array.from(elements);
    
    // window.webkit.messageHandlers.jsMessenger.postMessage(elements.slice(postLenght));
    for (let item of elementsArr.slice(postLenght)) {
        item.addEventListener('click', function() {
            getPostId(item);
        });
    }
    postLenght = elements.length;
});

observer.observe(document.body, {childList: true, subtree: true});
