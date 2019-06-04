
<navigate>
  <nav class="nav navbar-default navbar-static-top">
    <ul class="nav nav-pills">
      <li role="presentation">
        <a href="" onclick={home}>Home</a>
      </li>
      <li if={!logged} role="presentation">
        <a href="" onclick={login}>Login</a>
      </li>
      <li if={!logged} role="presentation">
        <a href="" onclick={join}>Join</a>
      </li>
      <li if={logged} role="presentation">
        <a href="" onclick={create}>New Post</a>
      </li>
      <li if={logged} role="presentation">
        <a href="" onclick={logout}>Logout</a>
      </li>
      <li if={logged &&  admin} role="presentation">
        <a href="" onclick={toadmin}>Administer</a>
      </li>
    </ul>
  </nav>
  <script>
    this.on("mount", () => {
    })
    this.on("update", (e) => {
      socket.emit('login:check',{from:'navigate:update'});
      socket.once("login-check-val", (data) => {
        if((data.user!==undefined && this.user!=data.user.username)){
          this.logged=data.logged
          this.admin=(data.user!==undefined&&data.user!==null&&data.user.is_admin==true)?true:false
          this.user=(data.user===null)?null:data.user.username;
          this.update()
        }else if((data.logged===undefined||data.logged==false)){
          this.logged=false;
          this.admin=false;
        }
      })
    })
    this.admin=false

    home(e){
      riot.route('/home','APG/Blog Home')
    }

    login(e){
      riot.route('/login','APG/Blog Login')
    }

    join(e){
      riot.route('/join','APG/Blog Join')
    }

    logout(e){
      riot.route('/logout','APG/Blog Logout')
    }

    toadmin(e){
      socket.emit('test');
      riot.route('/a','APG/Blog Administration')
    }
    create(e){
      riot.route('/create','APG/Blog New Post')
    }
  </script>

  <style scoped>
    :scope p {
      color: #000;
    }
  </style>
</navigate>
