
riot.tag2('view-story', '<p>Hi {message()}</p>', 'view-story p,[riot-tag="view-story"] p,[data-is="view-story"] p{ color: #000; }', '', function(opts) {
    this.message = function() {
      return 'there'
    }.bind(this)
});
