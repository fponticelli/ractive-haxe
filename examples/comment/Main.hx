package comment;

import ractive.Ractive;

class Main
{
	static function main()
	{
		// populate our app with some sample comments
		var sampleComments = [
			{ author: 'Rich', text: 'FIRST!!!' },
			{ author: 'anonymous', text: 'I disagree with the previous commenter' },
			{ author: 'Samuel L. Ipsum', text: "If they don't know, that means we never told anyone. And if we never told anyone it means we never made it back. Hence we die down here. Just as a matter of deductive logic.\n\nYou think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder." },
			{ author: 'Jon Grubber', text: '**Hey you guys!** I can use [markdown](http://daringfireball.net/projects/markdown/) in my posts' }
		];
		var view = new Ractive({
			el : "comments",
			template : template,
      noIntro : true,
			data : {
				comments : sampleComments
			}
		});

    view.on( 'post', function ( event ) {
      var comment;

      // stop the page reloading
      event.original.preventDefault();

      // we can just grab the comment data from the model, since
      // two-way binding is enabled by default
      comment = {
        author: view.get( 'author' ),
        text: view.get( 'text' )
      };

      view.get( 'comments' ).push( comment );

      // reset the form
      js.Browser.document.activeElement.blur();
      view.set({ author: '', text: '' });

      // fire an event so we can (for example) save the comment to a server
      view.fire( 'new comment', comment );
    });
	}

	static var template = "<div class='comment-box'>
  <h3>Comments</h3>
  
  <!-- comment list -->
  <div class='comment-list'> 
    {{#comments}}
      <div class='comment-block' intro='slide'>
        <h4 class='comment-author'>{{author}}</h4>
        
        <!-- we're using a triple-stache to render the comment body. There
          is a theoretical security risk in that triples insert HTML
          without sanitizing it, so a user could submit a comment with an
          XSS attack hidden in it, which would affect other users.

          In a real-life app, make sure you sanitize on the server
          before sending data to clients! -->
        <div class='comment-text'>{{{( text )}}}</div>
      </div>
    {{/comments}}
  </div>

  <!-- 'new comment' form -->
  <form name='comment-form' class='comment-form' proxy-submit='post'>
    
    <!-- author name -->
    <input class='author-input' value='{{author}}' placeholder='Your name' required>   
    
    <!-- comment body -->
    <textarea value='{{text}}' placeholder='Say something...' required></textarea>
    
    <!-- 'submit comment' button -->
    <input type='submit' value='Submit comment'>  
  </form>
</div>";
}