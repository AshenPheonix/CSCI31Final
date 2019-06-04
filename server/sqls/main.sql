--id: Login User
select username,name_f,name_l,is_admin
from users
where pw=:password,username=:uname;

--id: Get User
select username,name_f,name_l,is_admin
from users
where name_f=:ufn and name_l=:uln and username=:uname;

--id: Admin User View
select * from users;

--id: View Posts
select post_id,post_title,post_created,username from blog_posts;

--id: View Post
select * from blog_posts where post_id=:pid;
