
<main>
  <h4 >
    Welcome<span if={logged}> {username}</span>, feel free to look at any of our articles.<br>
    If you log in, or are logged in, you may edit and add articles as well.

    <div each={posts} class="col-md-12">
      <hr>
      <a href="" onclick={goto} src={this.post_id}>
        <div>
          {this.post_title}
          &nbsp;&nbsp;--{this.username}
        </div>
      </a>
      <hr>
    </div>

  </h4>
  <script>
    this.on("mount", () => {
      socket.emit('login:check',{from:'main mount'});
      socket.once("login-check-val", (data) => {
        if (data.logged) {
          this.logged=true
          this.username=data.user.username
        }else {
          this.logged=false;
          this.username=null;
        }

      })
      socket.removeListener('login-check-val')

      socket.emit('posts:ViewAll')
      socket.once("fetched", (data) => {
        this.posts=data;
        this.update()
      })
      socket.removeListener('fetched')

    })
    this.on("update", () => {
      socket.emit('login:check',{from:'main update'});
      socket.once("login-check-val", (data) => {
        if(data.user!==undefined && this.user!==data.user.username){
          this.logged=(data.user!==undefined)?true:false;
          this.admin=(data.user!==undefined&&data.user.is_admin==true)?true:false
          this.user=data.user.username;
          this.update()
        }
      })
    })

    goto(e){
      riot.route('/view/'+e.item.post_id,'APG/Blog Article')
    }
    var self=this;
  </script>

  <style scoped>
    :scope p {
      color: #000;
    }
  </style>
</main>
