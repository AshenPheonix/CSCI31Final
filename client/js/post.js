
riot.tag2('post', '<h1 if="{opts.error}">The Page you are looking for is not here</h1> <div if="{!opts.error}"> <div class="col-md-3 "> <h2>{opts.post_title}</h2> </div><br> <raw class="col-md-12"></raw> <br> <div class="col-md-offset-9 col-md-3"> --{opts.username} </div> </div>', 'post section,[riot-tag="post"] section,[data-is="post"] section{ color=#ff1515; }', '', function(opts) {
    this.on('mount',()=>{
    })
    this.on('updated',()=>{
      var body=opts.body;
      console.log(body)
      riot.tag('raw', '<section></section>', function(opts) {
        this.root.innerHTML = opts.r;
      });

      riot.mount('raw', {
        r: opts.post_body
      })
    })
});
