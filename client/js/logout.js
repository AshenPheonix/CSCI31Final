
riot.tag2('logout', '<h3 class="">Are you Sure?</h3><br> <div class="btn-group"> <input type="button" name="yes" value="Yes I Am" class="btn btn-primary" onclick="{yes}"> <input type="button" name="no" value="No I\'m not" class="btn btn-danger" onclick="{no}"> </div>', 'logout p,[riot-tag="logout"] p,[data-is="logout"] p{ color: #000; }', '', function(opts) {
    this.on("mount", () => {

    })

    this.yes = function(e){
      socket.emit('users:Logout');
      socket.once("logout-fin", () => {
        navigation.logged=false;
        navigation.update();
        riot.route('/home','APG/Blog Home');

      })
    }.bind(this)

});
