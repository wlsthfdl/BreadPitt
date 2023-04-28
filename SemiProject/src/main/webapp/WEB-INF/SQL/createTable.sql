---------- μ£Όλ¬Έ ??Έ ??΄λΈ?
CREATE TABLE tbl_order_detail (
	order_details_num     number(20)    NOT NULL, -- μ£Όλ¬Έ??Έλ²νΈ
	order_num             VARCHAR2(20)  NOT NULL, -- μ£Όλ¬Έλ²νΈ
	product_num           number(20)    NOT NULL, -- ??λ²νΈ
	order_name            VARCHAR2(50)  NOT NULL, -- μ£Όλ¬Έ??΄λ¦?
	order_quantity        number(5)     NOT NULL, -- μ£Όλ¬Έ??
	product_selling_price number(10)    NOT NULL, -- ???λ§€κ?κ²?
	product_main_image    VARCHAR2(50)  NULL,     -- ??????΄λ―Έμ?
	recipient_name        VARCHAR2(50)  NOT NULL, -- ?? Ή??΄λ¦?
	recipient_mobile      VARCHAR2(20)  NOT NULL, -- ?? Ή??΄???°λ²νΈ
	recipient_telephone   VARCHAR2(20)  NULL,     -- ?? Ή?? ? ? ?λ²νΈ
	shipping_address      VARCHAR2(500) NOT NULL, -- λ°°μ‘μ£Όμ
	forwarded_message     VARCHAR2(300) NULL,     -- λΆ??¬ ? ? ?¬ λ©μμ§?
	orderer_mobile        VARCHAR2(20)  NOT NULL, -- μ£Όλ¬Έ? ?΄???°λ²νΈ
	delivery_status       VARCHAR2(20)  NOT NULL, -- ??λ°°μ‘??
	payment_time          DATE          NOT NULL, -- κ²°μ ?κ°?
	use_mileage           number(10)    NOT NULL  -- λ§μΌλ¦¬μ??¬?©?΄?­
    ,CONSTRAINT PK_tbl_order_detail_order_details_num primary key(order_details_num)
    ,CONSTRAINT FK_tbl_order_detail_order_num foreign key(order_num) REFERENCES tbl_order(order_num)
    ,CONSTRAINT FK_tbl_order_detail_product_num foreign key(product_num) REFERENCES tbl_product(product_num)
);

--------------- μ£Όλ¬Έ ??΄λΈ?
CREATE TABLE tbl_order (
	order_num           VARCHAR2(20) NOT NULL, -- μ£Όλ¬Έλ²νΈ
	user_id             VARCHAR(40)  NULL,     -- ??΄?
	order_price_total   number(20)   NOT NULL, -- μ£Όλ¬Έμ΄μ‘
	order_mileage_total number(20)   NOT NULL, -- μ£Όλ¬Έμ΄λ§?Όλ¦¬μ?
	order_date          DATE         NOT NULL  -- μ£Όλ¬Έ?Ό?
    ,CONSTRAINT PK_tbl_order_order_num primary key(order_num)
    ,CONSTRAINT FK_tbl_order_user_id foreign key(user_id) REFERENCES tbl_member(user_id)
);

----------- ?₯λ°κ΅¬? ??΄λΈ?
CREATE TABLE tbl_cart (
	cart_num      number(20)  NOT NULL, -- ?₯λ°κ΅¬?λ²νΈ
	user_id       VARCHAR(40) NOT NULL, -- ??΄?
	product_num   number(20)  NOT NULL, -- ??λ²νΈ
	product_count NUMber(15) NOT NULL, -- ??κ°μ
	cart_date     DATE        NOT NULL  -- ??±?Ό?
     ,CONSTRAINT PK_tbl_cart_cart_num primary key(cart_num)
    ,CONSTRAINT FK_tbl_cart_user_id foreign key(user_id) REFERENCES tbl_member(user_id)
    ,CONSTRAINT FK_tbl_cart_product_num foreign key(product_num) REFERENCES tbl_product(product_num)
);

-- λ‘κ·Έ?Έ
CREATE TABLE tbl_login (
   user_id   VARCHAR2(40) NOT NULL,  -- ??΄?
   login_pwd  VARCHAR2(20) NOT NULL, -- λΉλ?λ²νΈ
   login_name VARCHAR2(20) NOT NULL  -- ?΄λ¦?
    ,constraint FK_tbl_login_user_id foreign key(user_id) 
                                references tbl_member(user_id) 
);

--λ‘κ·Έ?Έ κΈ°λ‘
create table tbl_login_history(
   user_id   VARCHAR2(40) NOT NULL  -- ??΄?
   ,login_date DATE       NOT NULL     -- λ‘κ·Έ?Έ? 
   ,clientIp   varchar2(30) NOT NULL      -- ??΄?Όμ£Όμ
    ,constraint FK_tbl_login_history_user_id foreign key(user_id) 
    references tbl_member(user_id) 
);


-- ??λ¬Έμ
create table tbl_inquiry(
   inquiry_num          NUMBER(30)  NOT NULL -- κΈ?λ²νΈ
   ,user_id             varchar2(40)   NOT NULL -- ??΄?
   ,product_num         NUMBER(20)    NOT NULL -- ??λ²νΈ
   ,inquiry_title       varchar2(20)  NOT NULL -- ? λͺ?
   ,inquiry_text        varchar2(30) NOT NULL -- λ³Έλ¬Έ
   ,inquiry_date        DATE          NOT NULL -- ??±? μ§?
   ,inquiry_state       varchar2(10)   NOT NULL -- λ¬Έμ??
   ,inquiry_answer_time DATE          NOT NULL -- ?΅λ³??κ°?
   ,inquiry_view_count  NUMBER(30) NOT NULL  -- μ‘°ν?
    ,constraint PK_tbl_member_inquiry_num primary key(inquiry_num)
    ,constraint FK_tbl_inquiry_user_id foreign key(user_id) 
                                references tbl_member(user_id)
);

create table tbl_product -- ?? ??΄λΈ?
(product_num        NUMBER(20)      not null
,category_num       NUMBER(20)      not null
,product_title      VARCHAR2(150)   not null
,main_image         number(20)      not null
,product_price      NUMBER(10)      not null
,product_detail     VARCHAR2(1000)  not null
,product_inventory  number(20)  not null
,product_date       date default sysdate
,sale_count         NUMBER(10)      null
,constraint PK_tbl_product_product_num primary key(product_num)
,constraint FK_tbl_product_category_num foreign key(category_num) references tbl_category(category_num)
);

create table tbl_category -- μΉ΄νκ³ λ¦¬ ??΄λΈ?
(category_num       NUMBER(20)      not null
,category_name      VARCHAR2(20)    not null
,constraint PK_tbl_category_category_num primary key(category_num)
);

create table tbl_addimage -- ??μΆκ??΄λ―Έμ? ??΄λΈ?
(image_num        NUMBER(20)      not null
,product_num      NUMBER(20)      not null
,image_name       VARCHAR2(20)    not null
,constraint PK_tbl_addimage_image_num primary key(image_num)
,constraint FK_tbl_addimage_product_num foreign key(product_num) references tbl_product(product_num)
);

-- κ΄?λ¦¬μ
create table tbl_admin
( admin_id   varchar2(40) not null -- κ΄?λ¦¬μ ??΄?
 ,admin_pwd  varchar2(20) not null -- κ΄?λ¦¬μ λΉλ?λ²νΈ
 ,constraint pk_tbl_admin_admin_id primary key(admin_id)
);

-- 
create table tbl_notice
( notice_num        number(10)              not null -- λ²νΈ
 ,admin_id          varchar2(40)              not null -- κ΄?λ¦¬μ ??΄? 
 ,notice_title      nvarchar2(100)            not null -- ? λͺ?
 ,notice_content    nvarchar2(500)            not null -- λ³Έλ¬Έ
 ,notice_date       date  default  sysdate    not null -- ??±? μ§?
 ,notice_writer     varchar2(10)              not null -- ??±?
 ,notice_viewcount  number(10)             not null -- μ‘°ν?
 ,notice_head       varchar2(10)              null     -- λ§λ¨Έλ¦?
 ,constraint pk_tbl_notice_notice_num primary key(notice_num)
 ,constraint fk_tbl_notice_admin_id foreign key(admin_id) REFERENCES tbl_admin(admin_id)
); 

-- κ΅¬λ§€?κΈ?
create table tbl_purchase_review
( purchase_review_id   number(10)             not null -- κ΅¬λ§€?κΈ°κ?λ²νΈ
 ,userid               varchar2(40)             not null -- ??΄?
 ,order_details_num    number(20)               not null -- μ£Όλ¬Έ??Έλ²νΈ
 ,product_num          number(20)               not null -- ??λ²νΈ
 ,review_content       nvarchar2(500)           not null -- κ΅¬λ§€?κΈ°λ΄?©
 ,review_rating        number(5)                not null -- κ΅¬λ§€?? 
 ,review_date          date  default  sysdate   not null -- κ΅¬λ§€?κΈ°μ?±? μ§?
 ,constraint pk_tbl_purchase_review_purchase_review_id primary key(purchase_review_id)
 ,constraint fk_tbl_tbl_purchase_review_userid foreign key(userid) REFERENCES tbl_member(user_id)
 ,constraint fk_tbl_tbl_purchase_review_order_details_num foreign key(order_details_num) REFERENCES tbl_order_detail(order_details_num)
 ,constraint fk_tbl_tbl_purchase_review_product_num foreign key(product_num) REFERENCES tbl_product(product_num)
);

-- ??? λ³?
CREATE TABLE tbl_member 
(
   user_id             VARCHAR2(40)           NOT NULL, -- ??΄?
   user_name           VARCHAR2(20)           NOT NULL, -- ?΄λ¦?
   pwd                 VARCHAR2(200)          NOT NULL, -- λΉλ?λ²νΈ
   email               VARCHAR2(40)           NOT NULL, -- ?΄λ©μΌ
   mobile              VARCHAR2(20)           NOT NULL, -- ?΄??? ?
   telephone           VARCHAR2(20)           NULL,     -- ? ? ? ?
   post_code           VARCHAR2(5)            NOT NULL, -- ?°?Έλ²νΈ
   address             VARCHAR2(200)          NOT NULL, -- μ£Όμ
   detailAddress       VARCHAR2(200)          NULL,     -- ??Έμ£Όμ
   extraAddress        VARCHAR2(200)          NULL,     -- λΆ?κ°?μ£Όμ
   gender              VARCHAR2(1)            NOT NULL, -- ?±λ³?
   birthday            VARCHAR2(10)           NULL,     -- ????Ό
   mileage             NUMBER DEFAULT 0       NULL,     -- λ§μΌλ¦¬μ?
   registerday         DATE DEFAULT SYSDATE   NOT NULL, -- κ°???Ό?
   lastPwdChange       DATE DEFAULT SYSDATE   NULL,     -- λ§μ?λ§λΉλ°?λ²νΈλ³?κ²½λ μ§?
   idle                NUMBER(1) DEFAULT 0    NOT NULL, -- ?΄λ¨Όν??¬λΆ?
   pwd_change_required DATE DEFAULT SYSDATE   NULL,     -- λΉλ?λ²νΈκ°±μ ???¬λΆ?
   status              NUMBER(1) DEFAULT 1    NOT NULL  -- ??΄?¬λΆ?
    ,constraint PK_tbl_member_userid primary key(user_id)
    ,constraint UQ_tbl_member_email  unique(email)
    ,constraint CK_tbl_member_gender check( gender in('1','2') )
    ,constraint CK_tbl_member_status check( status in(0,1) )
    ,constraint CK_tbl_member_idle check( idle in(0,1) )
);

-- ? ?μ’μ???΄λΈ?
CREATE TABLE tbl_product_like (
   user_id     VARCHAR(40) NOT NULL, -- ??΄?
   product_num number(20)  NOT NULL  -- ??λ²νΈ
);
