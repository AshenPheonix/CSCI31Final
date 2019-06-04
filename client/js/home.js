
riot.tag2('home', '<h4 class="c-heading c-heading--medium"> Welcome<span if="{window.user.logged}"> {window.user.username}</span>, feel free to look at any of our articles.<br> If you log in, or are logged in, you may edit and add articles as well. <div each="{window.posts.set}" class="c-card"> <a href="/view-story/{this.post_id}"> <div class="c-card__content"> {this.post_title} &nbsp;&nbsp;--{this.username} </div> </a> </div> </h4>', 'home p,[riot-tag="home"] p,[data-is="home"] p{ color: #000; }', '', function(opts) {
    this.on("mount", () => {
    })
    var self=this;
});
