-- MySQL Script generated by MySQL Workbench
-- 06/28/16 00:12:21
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema LIKE_IT
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LIKE_IT` ;

-- -----------------------------------------------------
-- Schema LIKE_IT
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LIKE_IT` DEFAULT CHARACTER SET utf8 ;
USE `LIKE_IT` ;

-- -----------------------------------------------------
-- Table `LIKE_IT`.`categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`categories` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`categories` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'synthetic key',
  `title` VARCHAR(255) NOT NULL COMMENT 'short informative title of category',
  `created_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date of creation this article',
  `description` TEXT NULL COMMENT 'full description of category, including rules, theme and goal category, reference on another useful categories',
  `parent_category` INT UNSIGNED NULL COMMENT 'each category can be located in other category. The parent (outer) category',
  `published` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'whether this category published by admin. 0 - not published, 1-published',
  PRIMARY KEY (`id`),
  INDEX `fk_parent_category_id_idx` (`parent_category` ASC),
  CONSTRAINT `fk_parent_category_id`
    FOREIGN KEY (`parent_category`)
    REFERENCES `LIKE_IT`.`categories` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'The post category';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`roles` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`roles` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'synthetic key',
  `name` VARCHAR(30) NOT NULL COMMENT 'sting name of role',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Describe existing roles ';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`users` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'synthetic key',
  `role_id` INT(11) UNSIGNED NOT NULL DEFAULT 3 COMMENT 'id of role (reference on roles table ) ',
  `login` VARCHAR(30) NOT NULL COMMENT 'login on which the user was registred. On each login can be registred only one user.',
  `password` VARCHAR(32) NOT NULL COMMENT 'user password on which user registred. store the md5 cashe',
  `email` VARCHAR(255) NOT NULL COMMENT 'The email, on which the user was registred. On each email can be registred only one user.',
  `last_name` VARCHAR(255) NULL COMMENT 'last name of user',
  `first_name` VARCHAR(255) NULL COMMENT 'original first name of user',
  `created_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date of registration',
  `updated_date` TIMESTAMP NULL COMMENT 'date of last info modifying',
  `banned` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'whether this user banned by admin. 1 - banned 0- not banned',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `user_login` (`login` ASC),
  UNIQUE INDEX `user_email` (`email` ASC),
  INDEX `user_role_id` (`role_id` ASC),
  CONSTRAINT `user_role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `LIKE_IT`.`roles` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Describe registred users';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`posts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`posts` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'искусственный ключ ',
  `user_id` INT UNSIGNED NOT NULL COMMENT 'reference on user who create the post',
  `category_id` INT UNSIGNED NULL COMMENT 'Reference on post category. Can by null if post not related to existing category',
  `title` VARCHAR(255) NOT NULL COMMENT 'The title (header) of post which describe the problem in short form',
  `content` TEXT NOT NULL COMMENT 'String body of post',
  `created_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date of creation the post',
  `updated_date` TIMESTAMP NULL COMMENT 'date of last modifying the post',
  `banned` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'whether this rate banned by admin. 1 - banned 0- not banned',
  PRIMARY KEY (`id`),
  INDEX `fk_post_user_id` (`user_id` ASC),
  INDEX `fk_post_category_id_idx` (`category_id` ASC),
  CONSTRAINT `post_category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `LIKE_IT`.`categories` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `post_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'The post - the question for help ';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`answers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`answers` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`answers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'synthetic key',
  `user_id` INT UNSIGNED NOT NULL COMMENT 'reference on user, who send this answer',
  `post_id` INT UNSIGNED NOT NULL COMMENT 'reference on post related to this answer',
  `content` TEXT NOT NULL COMMENT 'the message body',
  `created_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date of posting this answer',
  `updated_date` TIMESTAMP NULL COMMENT 'date of last updating this answer',
  `banned` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'whether this rate banned by admin. 1 - banned 0- not banned',
  INDEX `fk_comment_user_id` (`user_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_comment_post_id`
    FOREIGN KEY (`post_id`)
    REFERENCES `LIKE_IT`.`posts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Table encapsulate the answer entity. Answer can be posted under exact post.\n';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`rating`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`rating` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`rating` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'synthetic key',
  `user_id` INT UNSIGNED NOT NULL COMMENT 'user who define the mark',
  `answer_id` BIGINT UNSIGNED NOT NULL COMMENT 'id of answer in connection with which the mark was placed.',
  `rating` TINYINT(2) NOT NULL COMMENT 'mark expressed in digit',
  `created_date` VARCHAR(45) NOT NULL DEFAULT 'CURRENT_TIMESTAMP' COMMENT 'date of defining the mark',
  `updated_date` TIMESTAMP NULL COMMENT 'date of last modifying the mark',
  `banned` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'whether this rate banned by admin. 1 - banned 0- not banned',
  INDEX `fk_answer_rating_user_id` (`user_id` ASC),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `answer_and_user_id_UNIQUE` (`answer_id` ASC, `user_id` ASC),
  CONSTRAINT `fk_answer_rating_answers_id`
    FOREIGN KEY (`answer_id`)
    REFERENCES `LIKE_IT`.`answers` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_rating_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'The rating (mark) that can be placed on answer. Each user can define the rate on each answer one time. ';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`tags` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`tags` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'synthetic id used as primary key',
  `name` VARCHAR(20) NOT NULL COMMENT 'string name of tag',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
COMMENT = 'Describe all availiable tags';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`favorite_user_tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`favorite_user_tags` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`favorite_user_tags` (
  `user_id` INT UNSIGNED NOT NULL COMMENT 'reference on user who choose this tag as favorite',
  `tags_id` INT UNSIGNED NOT NULL COMMENT 'reference on tag choosen by user ',
  INDEX `fk_favorite_user_tags_tags_idx` (`tags_id` ASC),
  PRIMARY KEY (`user_id`, `tags_id`),
  CONSTRAINT `fk_favoriteTags_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_favoriteTags_tags1`
    FOREIGN KEY (`tags_id`)
    REFERENCES `LIKE_IT`.`tags` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'display relationship between users and tags, which this user marked as his favorites';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`posts_tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`posts_tags` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`posts_tags` (
  `post_id` INT UNSIGNED NOT NULL COMMENT 'reference on post, which was marked by this tag',
  `tag_id` INT UNSIGNED NOT NULL COMMENT 'Reference on tag related to this post',
  INDEX `fk_postsTags_tags_idx` (`tag_id` ASC),
  PRIMARY KEY (`post_id`, `tag_id`),
  CONSTRAINT `fk_postsTags_posts1`
    FOREIGN KEY (`post_id`)
    REFERENCES `LIKE_IT`.`posts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_postsTags_tags1`
    FOREIGN KEY (`tag_id`)
    REFERENCES `LIKE_IT`.`tags` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Describe relationship between the post an tags, which was choosed to mark this tal';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`comments` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`comments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'sythetic key',
  `user_id` INT UNSIGNED NOT NULL COMMENT 'user who posted the comment',
  `answers_id` BIGINT UNSIGNED NOT NULL COMMENT 'the answer under which this comment was posted',
  `content` TEXT NOT NULL COMMENT 'the string body of comment',
  `created_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date of posting the comment',
  `updated_date` TIMESTAMP NULL COMMENT 'date of last modifying the comment',
  `banned` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'whether this comment banned by admin. 1 - banned 0- not banned',
  PRIMARY KEY (`id`),
  INDEX `fk_comments-answers_idx` (`answers_id` ASC),
  INDEX `fk_users-authors_idx` (`user_id` ASC),
  CONSTRAINT `fk_comments-answers`
    FOREIGN KEY (`answers_id`)
    REFERENCES `LIKE_IT`.`answers` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_users-authors`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Commets can be posted under the answer to clarify some detail of answer.';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`categories_tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`categories_tags` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`categories_tags` (
  `category_id` INT UNSIGNED NOT NULL COMMENT 'reference on category',
  `tag_id` INT UNSIGNED NOT NULL COMMENT 'reference on tag ',
  INDEX `fk_categoryTags_tags_idx` (`tag_id` ASC),
  PRIMARY KEY (`category_id`, `tag_id`),
  CONSTRAINT `fk_category_tags_cat`
    FOREIGN KEY (`category_id`)
    REFERENCES `LIKE_IT`.`categories` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_category_tags_tag`
    FOREIGN KEY (`tag_id`)
    REFERENCES `LIKE_IT`.`tags` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'The relation between categories and posts';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`favorite_users_posts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`favorite_users_posts` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`favorite_users_posts` (
  `id` INT NOT NULL,
  `user_id` INT UNSIGNED NOT NULL COMMENT 'referense on user, who add this post in favorites',
  `post_id` INT UNSIGNED NOT NULL COMMENT 'reference on post',
  `comment` VARCHAR(225) NULL COMMENT 'the short comment placed on this favorite entity',
  INDEX `fk_favoritePosts_users1_idx` (`user_id` ASC),
  INDEX `fk_favoritePosts_posts1_idx` (`post_id` ASC),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UNIQUE` (`user_id` ASC, `post_id` ASC),
  CONSTRAINT `fk_favoritePosts_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_favoritePosts_posts`
    FOREIGN KEY (`post_id`)
    REFERENCES `LIKE_IT`.`posts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Desctribe relation between users and post, which was marked by him as favorite';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`readed_posts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`readed_posts` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`readed_posts` (
  `user_id` INT UNSIGNED NOT NULL COMMENT 'referense on user, who read this post ',
  `post_id` INT UNSIGNED NOT NULL COMMENT 'Ссылка на просматриваемый пост',
  PRIMARY KEY (`user_id`, `post_id`),
  INDEX `fk_readedPosts_posts1_idx` (`post_id` ASC),
  CONSTRAINT `fk_readedPosts_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_readedPosts_posts1`
    FOREIGN KEY (`post_id`)
    REFERENCES `LIKE_IT`.`posts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Relation between users and posts which was readed by them';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`rating_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`rating_comment` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`rating_comment` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'synthetic key',
  `rating_id` INT UNSIGNED NOT NULL COMMENT 'The rate(mark) which was commented',
  `type` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0-  negative size of answer 1 -  positive size of answer',
  `comment` VARCHAR(255) NOT NULL COMMENT 'Short description positive or negative characteristic of answer',
  `banned` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'whether this characteristic banned by admin',
  PRIMARY KEY (`id`),
  INDEX `fk_answerProperty_answers_rating1_idx` (`rating_id` ASC),
  CONSTRAINT `fk_answerProperty_answers_rating`
    FOREIGN KEY (`rating_id`)
    REFERENCES `LIKE_IT`.`rating` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'The negative and positive characteristics of answer';


-- -----------------------------------------------------
-- Table `LIKE_IT`.`answer_ups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`answer_ups` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`answer_ups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `answer_id` BIGINT UNSIGNED NOT NULL,
  `up` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_answers_ups_idx` (`answer_id` ASC),
  INDEX `fk_user_ups_idx` (`user_id` ASC),
  UNIQUE INDEX `unique_answer_ups` (`user_id` ASC, `answer_id` ASC),
  CONSTRAINT `fk_answers_ups`
    FOREIGN KEY (`answer_id`)
    REFERENCES `LIKE_IT`.`answers` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_ups`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LIKE_IT`.`comment_ups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LIKE_IT`.`comment_ups` ;

CREATE TABLE IF NOT EXISTS `LIKE_IT`.`comment_ups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `comment_id` INT UNSIGNED NOT NULL,
  `up` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_ups_idx` (`user_id` ASC),
  INDEX `fk_answers_ups0_idx` (`comment_id` ASC),
  UNIQUE INDEX `unique_comment_up` (`user_id` ASC, `comment_id` ASC),
  CONSTRAINT `fk_answers_ups0`
    FOREIGN KEY (`comment_id`)
    REFERENCES `LIKE_IT`.`comments` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_ups0`
    FOREIGN KEY (`user_id`)
    REFERENCES `LIKE_IT`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`categories`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`categories` (`id`, `title`, `created_date`, `description`, `parent_category`, `published`) VALUES (1, 'java наше все', DEFAULT, 'паблик о java', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`categories` (`id`, `title`, `created_date`, `description`, `parent_category`, `published`) VALUES (2, 'sql спасет мир', DEFAULT, 'паблик о sql ', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`categories` (`id`, `title`, `created_date`, `description`, `parent_category`, `published`) VALUES (3, 'frontend ', DEFAULT, 'изучаем вместе html и css', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`categories` (`id`, `title`, `created_date`, `description`, `parent_category`, `published`) VALUES (4, 'html ', DEFAULT, NULL, 3, DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`roles`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`roles` (`id`, `name`) VALUES (1, 'owner');
INSERT INTO `LIKE_IT`.`roles` (`id`, `name`) VALUES (2, 'admin');
INSERT INTO `LIKE_IT`.`roles` (`id`, `name`) VALUES (3, 'user');

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`users`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`users` (`id`, `role_id`, `login`, `password`, `email`, `last_name`, `first_name`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 3, 'lara', 'm23kujj', 'lara@mail.ru', NULL, NULL, '2016-06-14 14:33:04', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`users` (`id`, `role_id`, `login`, `password`, `email`, `last_name`, `first_name`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 3, 'kennni', 'nskofkjal', 'kenni@yahoo.com', NULL, NULL, '2016-03-15 14:33:04', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`users` (`id`, `role_id`, `login`, `password`, `email`, `last_name`, `first_name`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 3, 'winni', 'aljdsoifjoi3', 'winni@mail.ru', NULL, NULL, '2016-01-16 14:33:04', NULL, DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`posts`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`posts` (`id`, `user_id`, `category_id`, `title`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 1, 1, 'Публичный API для получения сегодняшней даты', 'Есть ли сервис, который предоставляет сегодняшнюю дату с API, да еще и безвозмездно?', '2016-08-14 14:33:04', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`posts` (`id`, `user_id`, `category_id`, `title`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 2, 1, 'путь до папки Downloads', 'Друзья, есть такой момент. Мне нужно узнать путь до папки Downloads, если есть флешка то флешки, если нет то памяти телефона.', '2016-09-15 14:33:04', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`posts` (`id`, `user_id`, `category_id`, `title`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 2, 2, 'Mysql Помогите оптимизировать запрос', '$mysql_query  = \"SELECT \". \"(SELECT SUM(sum)FROM transactions WHERE oper=1 AND user=$id) AS game, \" .\"(SELECT SUM(sum)FROM transactions WHERE oper=4 AND user=$id) AS discount, \". \"(SELECT SUM(sum)FROM transactions WHERE oper=3 AND user=$id) AS salery, \"', '2016-01-16 14:33:04', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`posts` (`id`, `user_id`, `category_id`, `title`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 3, 4, 'Как рисовать полупрозрачный лини на Canvas без наложения цвета?', 'Всем привет у меня тут образовалась проблема.Я делаю небольшую рисовалку и по заданию нужно чтобы можно было на канве рисовать линии с разным уровнем прозрачности. Вот тут пример такой рисовалки: https://jsfiddle.net/08cw6mh7/', '2016-05-16 14:33:04', NULL, DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`answers`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`answers` (`id`, `user_id`, `post_id`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 2, 4, 'пример конвертилки из цвета с прозрачностью в цвет без прозрачности с учетом фона: yolijn.com/convert-rgba-to-rgb ', '2016-02-16 14:33:04', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`answers` (`id`, `user_id`, `post_id`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 1, 3, 'SELECT user, user_name,        SUM(if(oper=1,sum,0)) as game,        SUM(if(oper=4,sum,0)) as discount,        SUM(if(oper=3,sum,0)) as salery,        SUM(if(oper=2 or oper=12,sum,0)) as costs   FROM transactions  WHERE oper in(1,2,3,4,12)  GROUP BY user, user_name', '2016-04-16 14:33:04', NULL, DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`rating`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`rating` (`id`, `user_id`, `answer_id`, `rating`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 2, 1, 5, '2016-05-16 14:33:04', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`rating` (`id`, `user_id`, `answer_id`, `rating`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 2, 2, 4, '2016-06-11 14:33:04', NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`rating` (`id`, `user_id`, `answer_id`, `rating`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 3, 2, 3, '2016-06-12 14:33:04', NULL, DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`tags`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`tags` (`id`, `name`) VALUES (1, 'java');
INSERT INTO `LIKE_IT`.`tags` (`id`, `name`) VALUES (2, 'sql');
INSERT INTO `LIKE_IT`.`tags` (`id`, `name`) VALUES (3, 'mysql');
INSERT INTO `LIKE_IT`.`tags` (`id`, `name`) VALUES (4, 'php');
INSERT INTO `LIKE_IT`.`tags` (`id`, `name`) VALUES (5, 'javascript');
INSERT INTO `LIKE_IT`.`tags` (`id`, `name`) VALUES (6, 'html');
INSERT INTO `LIKE_IT`.`tags` (`id`, `name`) VALUES (7, 'css');

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`favorite_user_tags`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`favorite_user_tags` (`user_id`, `tags_id`) VALUES (1, 1);
INSERT INTO `LIKE_IT`.`favorite_user_tags` (`user_id`, `tags_id`) VALUES (1, 2);
INSERT INTO `LIKE_IT`.`favorite_user_tags` (`user_id`, `tags_id`) VALUES (1, 3);
INSERT INTO `LIKE_IT`.`favorite_user_tags` (`user_id`, `tags_id`) VALUES (2, 1);
INSERT INTO `LIKE_IT`.`favorite_user_tags` (`user_id`, `tags_id`) VALUES (2, 4);
INSERT INTO `LIKE_IT`.`favorite_user_tags` (`user_id`, `tags_id`) VALUES (2, 6);
INSERT INTO `LIKE_IT`.`favorite_user_tags` (`user_id`, `tags_id`) VALUES (3, 5);
INSERT INTO `LIKE_IT`.`favorite_user_tags` (`user_id`, `tags_id`) VALUES (3, 6);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`posts_tags`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`posts_tags` (`post_id`, `tag_id`) VALUES (1, 1);
INSERT INTO `LIKE_IT`.`posts_tags` (`post_id`, `tag_id`) VALUES (2, 1);
INSERT INTO `LIKE_IT`.`posts_tags` (`post_id`, `tag_id`) VALUES (3, 2);
INSERT INTO `LIKE_IT`.`posts_tags` (`post_id`, `tag_id`) VALUES (3, 3);
INSERT INTO `LIKE_IT`.`posts_tags` (`post_id`, `tag_id`) VALUES (4, 6);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`comments`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`comments` (`id`, `user_id`, `answers_id`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 3, 1, 'Спасибо, отличная ссылка', DEFAULT, NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`comments` (`id`, `user_id`, `answers_id`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 3, 2, 'Помогло', DEFAULT, NULL, DEFAULT);
INSERT INTO `LIKE_IT`.`comments` (`id`, `user_id`, `answers_id`, `content`, `created_date`, `updated_date`, `banned`) VALUES (DEFAULT, 2, 2, 'Отлично!', DEFAULT, NULL, DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`categories_tags`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`categories_tags` (`category_id`, `tag_id`) VALUES (1, 1);
INSERT INTO `LIKE_IT`.`categories_tags` (`category_id`, `tag_id`) VALUES (2, 2);
INSERT INTO `LIKE_IT`.`categories_tags` (`category_id`, `tag_id`) VALUES (3, 5);
INSERT INTO `LIKE_IT`.`categories_tags` (`category_id`, `tag_id`) VALUES (3, 6);
INSERT INTO `LIKE_IT`.`categories_tags` (`category_id`, `tag_id`) VALUES (3, 7);
INSERT INTO `LIKE_IT`.`categories_tags` (`category_id`, `tag_id`) VALUES (4, 6);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`favorite_users_posts`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`favorite_users_posts` (`id`, `user_id`, `post_id`, `comment`) VALUES (DEFAULT, 1, 1, NULL);
INSERT INTO `LIKE_IT`.`favorite_users_posts` (`id`, `user_id`, `post_id`, `comment`) VALUES (DEFAULT, 1, 2, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`readed_posts`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`readed_posts` (`user_id`, `post_id`) VALUES (1, 1);
INSERT INTO `LIKE_IT`.`readed_posts` (`user_id`, `post_id`) VALUES (1, 3);
INSERT INTO `LIKE_IT`.`readed_posts` (`user_id`, `post_id`) VALUES (2, 2);
INSERT INTO `LIKE_IT`.`readed_posts` (`user_id`, `post_id`) VALUES (2, 3);
INSERT INTO `LIKE_IT`.`readed_posts` (`user_id`, `post_id`) VALUES (2, 4);
INSERT INTO `LIKE_IT`.`readed_posts` (`user_id`, `post_id`) VALUES (3, 3);
INSERT INTO `LIKE_IT`.`readed_posts` (`user_id`, `post_id`) VALUES (3, 4);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LIKE_IT`.`rating_comment`
-- -----------------------------------------------------
START TRANSACTION;
USE `LIKE_IT`;
INSERT INTO `LIKE_IT`.`rating_comment` (`id`, `rating_id`, `type`, `comment`, `banned`) VALUES (DEFAULT, 1, 1, 'done', DEFAULT);
INSERT INTO `LIKE_IT`.`rating_comment` (`id`, `rating_id`, `type`, `comment`, `banned`) VALUES (DEFAULT, 3, 1, 'norm', DEFAULT);

COMMIT;

