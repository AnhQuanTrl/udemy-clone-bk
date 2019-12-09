DROP DATABASE IF EXISTS DBS_Assignment;
SET GLOBAL event_scheduler = ON;
CREATE DATABASE IF NOT EXISTS DBS_Assignment CHARACTER SET utf8;

USE DBS_Assignment;

-- 													CREATE TABLES
DROP TABLE IF EXISTS tbl_CONTEXT;
DROP TABLE IF EXISTS tbl_ANSWER;
DROP TABLE IF EXISTS tbl_QUESTION;
DROP TABLE IF EXISTS tbl_TEACH;
DROP TABLE IF EXISTS tbl_ENROLL;
DROP TABLE IF EXISTS tbl_FINISH;
DROP TABLE IF EXISTS tbl_MESSAGE;
DROP TABLE IF EXISTS tbl_UNCACHED_RESOURCE;
DROP TABLE IF EXISTS tbl_EMBEDDED_RESOURCE;
DROP TABLE IF EXISTS tbl_RESOURCE;
DROP TABLE IF EXISTS tbl_ASSIGNMENT_QUIZ;
DROP TABLE IF EXISTS tbl_ASSIGNMENT;
DROP TABLE IF EXISTS tbl_CODING_EXERCISE;
DROP TABLE IF EXISTS tbl_QUIZ_ANSWER;
DROP TABLE IF EXISTS tbl_QUIZ;
DROP TABLE IF EXISTS tbl_PTQ;
DROP TABLE IF EXISTS tbl_ARTICAL;
DROP TABLE IF EXISTS tbl_VIDEO_SLIDE;
DROP TABLE IF EXISTS tbl_CAPTION;
DROP TABLE IF EXISTS tbl_LECTURE;
DROP TABLE IF EXISTS tbl_VIDEO;
DROP TABLE IF EXISTS tbl_COMPOSE;
DROP TABLE IF EXISTS tbl_SECTION;
DROP TABLE IF EXISTS tbl_ITEM;
DROP TABLE IF EXISTS tbl_ANNOUNCEMENT;
DROP TABLE IF EXISTS tbl_COURSE_TOPIC;
DROP TABLE IF EXISTS tbl_COURSE;
DROP TABLE IF EXISTS tbl_SUBCATEGORY;
DROP TABLE IF EXISTS tbl_CATEGORY;
DROP TABLE IF EXISTS tbl_USER;

-- 																===== USER =====
CREATE TABLE IF NOT EXISTS tbl_USER (
	id					INT UNSIGNED NOT NULL AUTO_INCREMENT,
	email				VARCHAR(256) NOT NULL,
	password			VARCHAR(256) NOT NULL,
	first_name			VARCHAR(128) NOT NULL,
	last_name			VARCHAR(128) NOT NULL,
	profile_picture		VARCHAR(256),
	bigraphy			TEXT,
	headline			VARCHAR(64),
	website				VARCHAR(256),
	facebook			VARCHAR(256),
	twitter				VARCHAR(256),
	linkedln			VARCHAR(256),
	youtube				VARCHAR(256),
	user_language		VARCHAR(64) NOT NULL DEFAULT "English",
	profile_setting		BOOL NOT NULL DEFAULT FALSE,
	instructor_flag		BOOL NOT NULL DEFAULT FALSE,
	student_flag		BOOL NOT NULL DEFAULT TRUE,
	PRIMARY KEY (id),
    UNIQUE (email)
);
-- 																CATEGORY
CREATE TABLE IF NOT EXISTS tbl_CATEGORY (
	id 		INT UNSIGNED	NOT NULL AUTO_INCREMENT,
	name 	VARCHAR(256) 	NOT NULL 	DEFAULT "Default Category's name",
	PRIMARY KEY (id),
    UNIQUE(name)
);
-- 																SUBCATEGORY
CREATE TABLE IF NOT EXISTS tbl_SUBCATEGORY (
	id 				INT UNSIGNED	NOT NULL AUTO_INCREMENT,
	name 			VARCHAR(256) 	NOT NULL 	DEFAULT "Default Subcategory's name",
	category_id 	INT UNSIGNED	NOT NULL,
	
	PRIMARY KEY (id),
	UNIQUE (name),
	FOREIGN KEY (category_id) REFERENCES tbl_CATEGORY(id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																COURSE
CREATE TABLE IF NOT EXISTS tbl_COURSE (
	id 					INT UNSIGNED	NOT NULL AUTO_INCREMENT,
	main_title 			VARCHAR(256) 	NOT NULL 	DEFAULT "Default Main Title",
	sub_title 			VARCHAR(256)  	DEFAULT "Defult Sub Title",
	description 		LONGTEXT,
	publish_status 		BOOL 			NOT NULL 	DEFAULT FALSE,
	promotional_video 	VARCHAR(256),
	image 				VARCHAR(256),
	course_language 	VARCHAR(64) 	NOT NULL 	DEFAULT "English",
	course_level 		ENUM('Beginner', 'Intermidate', 'Expert', 'All Levels') NOT NULL DEFAULT 'All Levels',
	price 				DECIMAL(10,2) 	NOT NULL 	DEFAULT 0.00,
	welcome_message 	TEXT,
	owner_id 			INT UNSIGNED	NOT NULL,
	sub_category_id 	INT UNSIGNED	NOT NULL,
	updated_date 		TIMESTAMP		DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
    CONSTRAINT constraint_price CHECK (price > 0.0),
	FOREIGN KEY (sub_category_id) REFERENCES tbl_SUBCATEGORY(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (owner_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																COURSE_TOPIC
CREATE TABLE IF NOT EXISTS tbl_COURSE_TOPIC (
	course_id 	INT UNSIGNED	NOT NULL,
	topic 		VARCHAR(64) 	NOT NULL 	DEFAULT "Default Topic",
	
	PRIMARY KEY (course_id, topic),
	FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																ANNOUNCEMENT
CREATE TABLE IF NOT EXISTS tbl_ANNOUNCEMENT (
	id 				INT UNSIGNED NOT NULL AUTO_INCREMENT,
	course_id 		INT UNSIGNED NOT NULL,
	instructor_id 	INT UNSIGNED NOT NULL,
	content			TEXT NOT NULL,
    created_date 	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id, course_id, instructor_id),
	FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (instructor_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT content_char_length CHECK (CHAR_LENGTH(content) < 1024)
-- 	FOREIGN KEY (instructor_id) REFERENCES 
);
-- 																ITEM
CREATE TABLE IF NOT EXISTS tbl_ITEM (
	item_id 	INT UNSIGNED NOT NULL AUTO_INCREMENT,
	course_id	INT UNSIGNED NOT NULL,
    name 		VARCHAR(256) NOT NULL,
	PRIMARY KEY (item_id, course_id),
    UNIQUE(item_id, name),
	FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																SECTION
CREATE TABLE IF NOT EXISTS tbl_SECTION (
	section_id	INT UNSIGNED NOT NULL AUTO_INCREMENT,
	course_id 	INT UNSIGNED NOT NULL,
    name VARCHAR(256) NOT NULL,
	section_order INT UNSIGNED NOT NULL,
	PRIMARY KEY (section_id, course_id),
	FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																COMPOSE
CREATE TABLE IF NOT EXISTS tbl_COMPOSE (
	item_id				INT UNSIGNED NOT NULL,
	course_id_item		INT UNSIGNED NOT NULL,
	section_id			INT UNSIGNED NOT NULL,
	course_id_section 	INT UNSIGNED NOT NULL,
	item_order 			INT UNSIGNED NOT NULL,
	PRIMARY KEY (course_id_item, item_id),
    UNIQUE (item_order),
	FOREIGN KEY (item_id, course_id_item) REFERENCES tbl_ITEM(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (section_id, course_id_section) REFERENCES tbl_SECTION(section_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																LECTURE
CREATE TABLE IF NOT EXISTS tbl_LECTURE (
	item_id				INT UNSIGNED NOT NULL,
	course_id 			INT UNSIGNED NOT NULL,
	PRIMARY KEY (item_id, course_id),
    FOREIGN KEY (item_id, course_id) REFERENCES tbl_ITEM(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																VIDEO
CREATE TABLE IF NOT EXISTS tbl_VIDEO (
	item_id				INT UNSIGNED NOT NULL,
	course_id			INT UNSIGNED NOT NULL,
	is_previewable		BOOL NOT NULL DEFAULT FALSE,
	duration			DECIMAL(5,2) NOT NULL DEFAULT 0.00,
	url					VARCHAR(256) NOT NULL,
	
	PRIMARY KEY (item_id, course_id),
    FOREIGN KEY (item_id, course_id) REFERENCES tbl_LECTURE(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																CAPTION
CREATE TABLE IF NOT EXISTS tbl_CAPTION (
	item_id				INT UNSIGNED NOT NULL,
	course_id			INT UNSIGNED NOT NULL,
	caption_language	VARCHAR(64) NOT NULL DEFAULT "English",
	vtt					VARCHAR(256) NOT NULL,
	
	PRIMARY KEY (item_id, course_id, caption_language, vtt),
	FOREIGN KEY (item_id, course_id) REFERENCES tbl_VIDEO(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																VIDEO_SLIDE
CREATE TABLE IF NOT EXISTS tbl_VIDEO_SLIDE (
	item_id		INT UNSIGNED NOT NULL,
	course_id	INT UNSIGNED NOT NULL,
	slide_url	VARCHAR(256) NOT NULL,
	sync_url	VARCHAR(256),
	video_url 	VARCHAR(256) NOT NULL,
	duration	DECIMAL(5,2) NOT NULL DEFAULT 0.0,
	PRIMARY KEY (item_id, course_id),
    FOREIGN KEY (item_id, course_id) REFERENCES tbl_LECTURE(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																ARTICAL
CREATE TABLE IF NOT EXISTS tbl_ARTICAL (
	item_id		INT UNSIGNED NOT NULL,
	course_id	INT UNSIGNED NOT NULL,
	content		LONGTEXT NOT NULL,
	
	PRIMARY KEY (item_id, course_id),
    FOREIGN KEY (item_id, course_id) REFERENCES tbl_LECTURE(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																PTQ
CREATE TABLE IF NOT EXISTS tbl_PTQ (
	item_id			INT UNSIGNED NOT NULL,
	course_id 		INT UNSIGNED NOT NULL,
	minimum_score	INT NOT NULL,
	is_randomize	BOOL NOT NULL DEFAULT FALSE,
	description		LONGTEXT,
	
	PRIMARY KEY (item_id, course_id),
    FOREIGN KEY (item_id, course_id) REFERENCES tbl_ITEM(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																QUIZ
CREATE TABLE IF NOT EXISTS tbl_QUIZ (
	id				INT UNSIGNED NOT NULL AUTO_INCREMENT,
	item_id			INT UNSIGNED NOT NULL,
	course_id		INT UNSIGNED NOT NULL,
	content			LONGTEXT NOT NULL,
	knowledge_area	VARCHAR(64),
	
	PRIMARY KEY (id, item_id, course_id),
	FOREIGN KEY (item_id, course_id) REFERENCES tbl_PTQ(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																RIGHT_ANSWER
CREATE TABLE IF NOT EXISTS tbl_QUIZ_ANSWER (
	quiz_id		INT UNSIGNED NOT NULL,
	item_id		INT UNSIGNED NOT NULL,
	course_id	INT UNSIGNED NOT NULL,
	content		VARCHAR(512) NOT NULL,
	rightness	BOOL NOT NULL,
	PRIMARY KEY (quiz_id, item_id, course_id, content),
	FOREIGN KEY (quiz_id, item_id, course_id) REFERENCES tbl_QUIZ(id, item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																CODING_EXERCISE
CREATE TABLE IF NOT EXISTS tbl_CODING_EXERCISE (
	item_id					INT UNSIGNED NOT NULL,
	course_id				INT UNSIGNED NOT NULL,
	initial_code			VARCHAR(256) NOT NULL,
	test_code				VARCHAR(256),	
	programming_language	VARCHAR(64) NOT NULL,
	
	PRIMARY KEY (item_id, course_id),
    FOREIGN KEY (item_id, course_id) REFERENCES tbl_PTQ(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																ASSIGNMENT
CREATE TABLE IF NOT EXISTS tbl_ASSIGNMENT (
	item_id					INT UNSIGNED NOT NULL,
	course_id				INT UNSIGNED NOT NULL,
	instruction				TEXT,
	video					VARCHAR(256),
	assignment_language 	VARCHAR(64),
	
	PRIMARY KEY (item_id, course_id),
    FOREIGN KEY (item_id, course_id) REFERENCES tbl_PTQ(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																ASSIGNMENT_QUIZ
CREATE TABLE IF NOT EXISTS tbl_ASSIGNMENT_QUIZ (
	id			INT UNSIGNED NOT NULL AUTO_INCREMENT,
	item_id		INT UNSIGNED NOT NULL,
	course_id	INT UNSIGNED NOT NULL,
	question	TEXT NOT NULL,
	solution	TEXT,
	
	PRIMARY KEY (id, item_id, course_id),
	FOREIGN KEY (item_id, course_id) REFERENCES tbl_ASSIGNMENT(item_id, course_id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- 																LIBRARY_ENTRY
CREATE TABLE IF NOT EXISTS tbl_LIBRARY_ENTRY (
	id				INT UNSIGNED NOT NULL AUTO_INCREMENT,
	instructor_id	INT UNSIGNED NOT NULL,
    title 			VARCHAR(256) NOT NULL,
	url				VARCHAR(256) NOT NULL,
	resource_type	VARCHAR(64),
	status			BOOL DEFAULT FALSE,
	uploaded_date	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (title),
	PRIMARY KEY (id, instructor_id),
	FOREIGN KEY (instructor_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																EMBEDDED_RESOURCE
-- CREATE TABLE IF NOT EXISTS tbl_EMBEDDED_RESOURCE (
-- 	item_id			INT UNSIGNED NOT NULL,
-- 	course_id		INT UNSIGNED NOT NULL,
-- 	resource_id		INT UNSIGNED NOT NULL,
-- 	instructor_id	INT UNSIGNED NOT NULL,
-- 	title			VARCHAR(256),
-- 	
-- 	PRIMARY KEY (item_id, course_id, instructor_id, resource_id),
-- 	FOREIGN KEY (item_id, course_id) REFERENCES tbl_LECTURE(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE,
-- 	FOREIGN KEY (resource_id, instructor_id) REFERENCES tbl_RESOURCE(id, instructor_id) ON DELETE CASCADE ON UPDATE CASCADE
-- );
-- 																RESOURCE
CREATE TABLE IF NOT EXISTS tbl_RESOURCE (
	item_id 	INT UNSIGNED NOT NULL,
	course_id	INT UNSIGNED NOT NULL,
	title		VARCHAR(256) NOT NUll,
	url			VARCHAR(256) NOT NULL,
	PRIMARY KEY (item_id, course_id, title, url),
	FOREIGN KEY (item_id, course_id) REFERENCES tbl_LECTURE(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																MESSAGE
CREATE TABLE IF NOT EXISTS tbl_MESSAGE (
	from_id			INT UNSIGNED NOT NULL,
	to_id			INT UNSIGNED NOT NULL,
	created_date	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	content			LONGTEXT NOT NULL,
	PRIMARY KEY (from_id, to_id),
	FOREIGN KEY (from_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (to_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE 
);
-- 																FINISH
CREATE TABLE IF NOT EXISTS tbl_FINISH (
	user_id		INT UNSIGNED NOT NULL,	
	item_id		INT UNSIGNED NOT NULL,
	course_id	INT UNSIGNED NOT NULL,
	
	PRIMARY KEY (user_id, item_id, course_id),
	FOREIGN KEY (user_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (item_id, course_id) REFERENCES tbl_ITEM(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																ENROLL
CREATE TABLE IF NOT EXISTS tbl_ENROLL (
	user_id			INT UNSIGNED NOT NULL,
	course_id		INT UNSIGNED NOT NULL,
	rating			INT UNSIGNED,
	comment			LONGTEXT,
	is_archived		BOOL NOT NULL DEFAULT FALSE,
	is_favorite		BOOL NOT NULL DEFAULT FALSE,
	enroll_date		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	is_finished		BOOL NOT NULL DEFAULT FALSE,
	paid_price		DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
	PRIMARY KEY (user_id, course_id),
    CONSTRAINT constraint_rating CHECK (rating > 0 AND rating <= 5),
	FOREIGN KEY (user_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON UPDATE CASCADE #ON DELETE RESTRICT 
    #prevent teacher from deleting course that still has user enroll
);
-- 																TEACH
CREATE TABLE IF NOT EXISTS tbl_TEACH (
	instructor_id	INT UNSIGNED NOT NULL,
	course_id		INT UNSIGNED NOT NULL,
	permission		BIT(8) NOT NULL DEFAULT b'11111111',
	share			DECIMAL(5,2) NOT NULL DEFAULT 100.00,
	#INSERT TRIGGER FOR SHARE
	PRIMARY KEY (instructor_id, course_id),
	FOREIGN KEY (instructor_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT share_constraint CHECK (share <= 100.00)
);
-- 																QUESTION
CREATE TABLE IF NOT EXISTS tbl_QUESTION (
	id				INT UNSIGNED NOT NULL AUTO_INCREMENT,
	student_id		INT UNSIGNED,
	course_id		INT UNSIGNED NOT NULL,
	content			LONGTEXT,		
	created_date	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	PRIMARY KEY (id),
	FOREIGN KEY (student_id) REFERENCES tbl_USER(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																ANSWER
CREATE TABLE IF NOT EXISTS tbl_ANSWER (
	id				INT UNSIGNED NOT NULL auto_increment,
	question_id		INT UNSIGNED NOT NULL,
	user_id			INT UNSIGNED NOT NULL,
	content			LONGTEXT,
	created_date	TIMESTAMP,
	PRIMARY KEY (id, question_id),
	FOREIGN KEY (question_id) REFERENCES tbl_QUESTION(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (user_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 																CONTEXT
CREATE TABLE IF NOT EXISTS tbl_CONTEXT (
	question_id		INT UNSIGNED NOT NULL,
	item_id			INT UNSIGNED,
	course_id		INT UNSIGNED,
	
	PRIMARY KEY (question_id),
	FOREIGN KEY (question_id) REFERENCES tbl_QUESTION(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (item_id, course_id) REFERENCES tbl_LECTURE(item_id, course_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS tbl_SHOPPING_CART(
	id INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED  NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (user_id) REFERENCES tbl_USER(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS tbl_SHOPPING_CART_COURSE(
	shopping_cart_id INT UNSIGNED  NOT NULL,
    course_id INT UNSIGNED  NOT NULL,
    PRIMARY KEY(shopping_cart_id, course_id),
    FOREIGN KEY (shopping_cart_id) REFERENCES tbl_SHOPPING_CART(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS tbl_COUPON(
	coupon_code CHAR(10) NOT NULL,
    expired_date TIMESTAMP NOT NULL,
    discount_percentage DECIMAL(5,2) NOT NULL,
    is_primary BOOL,
    PRIMARY KEY(coupon_code),
    CONSTRAINT percentage_constraint CHECK (discount_percentage <= 80.00)
);

CREATE TABLE IF NOT EXISTS tbl_AFFECTED_BY(
	shopping_cart_id INT UNSIGNED NOT NULL,
    coupon_code CHAR(10) NOT NULL,
	PRIMARY KEY (shopping_cart_id, coupon_code),
    FOREIGN KEY (shopping_cart_id) REFERENCES tbl_SHOPPING_CART(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (coupon_code) REFERENCES tbl_COUPON(coupon_code) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS tbl_DISCOUNT(
	course_id INT UNSIGNED NOT NULL,
    coupon_code CHAR(10) NOT NULL,
    PRIMARY KEY (course_id, coupon_code),
    FOREIGN KEY (course_id) REFERENCES tbl_COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (coupon_code) REFERENCES tbl_COUPON(coupon_code) ON DELETE CASCADE ON UPDATE CASCADE
)

