
riot.tag2('login', '<form> <fieldset> <legend>Log In To APG/Blog </legend> <div class="form-group"> <label for="username">User Name</label> <input type="text" name="username" id="username" value="" placeholder="Username"> </div> <div class="form-group"> <label for="password">Pass Word</label> <input type="password" name="password" id="password" value="" placeholder="Password Please"> </div> <button type="submit" class="btn btn-primary" id="subbut" onclick="{submit}">Submit</button> <span class="Error-Field" id="errorfield" __hidden="{!error}"> Error in Username or Password </span> </fieldset> </form>', 'login .Error-Field,[riot-tag="login"] .Error-Field,[data-is="login"] .Error-Field{ background-color: red; color: white; } login :disabled,[riot-tag="login"] :disabled,[data-is="login"] :disabled{ }', '', function(opts) {
  this.error=false;
  this.on("mount", () => {
  })

  this.submit = function(e){
    var temp={username:document.getElementById('username').value,password:document.getElementById('password').value}
    if (temp.uname==="" || temp.pw==="") {
      this.error=true;
      document.getElementById('errorfield').innerText='Please fill out the entirety of the form';
    }else {
      this.error=false;
      document.getElementById('subbut').disabled=true;
      socket.emit('users:login',temp)
      socket.once("log-fin", (data) => {
        if (data.success!==undefined && data.success==false) {
          document.getElementById('subbut').disabled=false;
          this.error=true;
          document.getElementById('errorfield').innerText='Username and/or password not found'
          this.update()
        }else {
          riot.vdom[0].update();
          riot.route('/','APG Home');
        }
      })
    }

    this.on("unmount", () => {
    })
  }.bind(this)
});
