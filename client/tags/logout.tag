
<logout>
  <h3 class="">Are you Sure?</h3><br>
  <div class="btn-group">
    <input type="button" name="yes" value="Yes I Am" class="btn btn-primary" onclick={yes}>
    <input type="button" name="no" value="No I'm not" class="btn btn-danger" onclick={no}>
  </div>

  <script>
    this.on("mount", () => {

    })


    yes(e){
      socket.emit('users:Logout');
      socket.once("logout-fin", () => {
        navigation.logged=false;
        navigation.update();
        riot.route('/home','APG/Blog Home');

      })
    }

  </script>

  <style scoped>
    :scope p {
      color: #000;
    }
  </style>
</logout>
