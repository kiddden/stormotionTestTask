// Method that allows us to send a message to our app with the mata-ml-post-id
function getPostId(element) {
    window.webkit.messageHandlers.jsMessenger.postMessage(element.getAttribute('data-ml-post-id'));
}

var postLenght = 0;

// Setting up a listener to each element(article/post) on the document(page) so it sends us data-ml-post-id of the clicked element.
window.onload = function() {
    let elements = document.getElementsByClassName('list-item');
    for (let item of elements) {
        item.addEventListener('click', function() {
            getPostId(item);
        });
    }
    postLenght = elements.length;
}

// Checking whenever the document(webpage) mutates, meaning that new post were loaded
var observer = new MutationObserver(function(mutations) {
    let elements = document.getElementsByClassName('list-item');
    let elementsArr = Array.from(elements);
    
// Splitting array of elements into two slices, and working with the second slice that doesn't include the elements that we already set listeners for.
// The main purpose of this is to avoid setting listeners to an element that already has one.
    for (let item of elementsArr.slice(postLenght)) {
        item.addEventListener('click', function() {
            getPostId(item);
        });
    }
    postLenght = elements.length;
});

observer.observe(document.body, {childList: true, subtree: true});
