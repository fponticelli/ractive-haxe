(function () { "use strict";
var comment = {}
comment.Main = function() { }
comment.Main.main = function() {
	var sampleComments = [{ author : "Rich", text : "FIRST!!!"},{ author : "anonymous", text : "I disagree with the previous commenter"},{ author : "Samuel L. Ipsum", text : "If they don't know, that means we never told anyone. And if we never told anyone it means we never made it back. Hence we die down here. Just as a matter of deductive logic.\n\nYou think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder."},{ author : "Jon Grubber", text : "**Hey you guys!** I can use [markdown](http://daringfireball.net/projects/markdown/) in my posts"}];
	var view = new Ractive({ el : "comments", template : comment.Main.template, noIntro : true, data : { comments : sampleComments}});
	view.on("post",function(event) {
		var comment;
		event.original.preventDefault();
		comment = { author : view.get("author"), text : view.get("text")};
		view.get("comments").push(comment);
		js.Browser.document.activeElement.blur();
		view.set({ author : "", text : ""});
		view.fire("new comment",comment);
	});
}
var js = {}
js.Browser = function() { }
var q = window.jQuery;
js.JQuery = q;
comment.Main.template = "<div class='comment-box'>\n  <h3>Comments</h3>\n  \n  <!-- comment list -->\n  <div class='comment-list'> \n    {{#comments}}\n      <div class='comment-block' intro='slide'>\n        <h4 class='comment-author'>{{author}}</h4>\n        \n        <!-- we're using a triple-stache to render the comment body. There\n          is a theoretical security risk in that triples insert HTML\n          without sanitizing it, so a user could submit a comment with an\n          XSS attack hidden in it, which would affect other users.\n\n          In a real-life app, make sure you sanitize on the server\n          before sending data to clients! -->\n        <div class='comment-text'>{{{( text )}}}</div>\n      </div>\n    {{/comments}}\n  </div>\n\n  <!-- 'new comment' form -->\n  <form name='comment-form' class='comment-form' proxy-submit='post'>\n    \n    <!-- author name -->\n    <input class='author-input' value='{{author}}' placeholder='Your name' required>   \n    \n    <!-- comment body -->\n    <textarea value='{{text}}' placeholder='Say something...' required></textarea>\n    \n    <!-- 'submit comment' button -->\n    <input type='submit' value='Submit comment'>  \n  </form>\n</div>";
js.Browser.document = typeof window != "undefined" ? window.document : null;
comment.Main.main();
})();
