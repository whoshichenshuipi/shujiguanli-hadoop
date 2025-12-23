-- Core tables for library system (no data)

CREATE TABLE IF NOT EXISTS category (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  code VARCHAR(50) UNIQUE NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS book (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  isbn VARCHAR(32) UNIQUE NOT NULL,
  title VARCHAR(255) NOT NULL,
  category_id BIGINT NOT NULL,
  author VARCHAR(255),
  publish_year INT,
  total_copies INT DEFAULT 0,
  available_copies INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_book_category FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE IF NOT EXISTS reader (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(100),
  type VARCHAR(30) DEFAULT 'student',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS borrow_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  book_id BIGINT NOT NULL,
  reader_id BIGINT NOT NULL,
  borrow_time DATETIME NOT NULL,
  due_time DATETIME NOT NULL,
  return_time DATETIME,
  status VARCHAR(20) NOT NULL,
  renew_times INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_borrow_book (book_id),
  KEY idx_borrow_reader (reader_id),
  KEY idx_borrow_status (status),
  CONSTRAINT fk_borrow_book FOREIGN KEY (book_id) REFERENCES book(id),
  CONSTRAINT fk_borrow_reader FOREIGN KEY (reader_id) REFERENCES reader(id)
);

CREATE TABLE IF NOT EXISTS stat_book_popular (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  stat_date DATE NOT NULL,
  period VARCHAR(10) NOT NULL,
  book_id BIGINT NOT NULL,
  borrow_cnt BIGINT DEFAULT 0,
  unique_reader_cnt BIGINT DEFAULT 0,
  renew_cnt BIGINT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_book_period (stat_date, period, book_id),
  CONSTRAINT fk_stat_book FOREIGN KEY (book_id) REFERENCES book(id)
);

CREATE TABLE IF NOT EXISTS stat_reader_behavior (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  stat_date DATE NOT NULL,
  period VARCHAR(10) NOT NULL,
  reader_id BIGINT NOT NULL,
  borrow_cnt BIGINT DEFAULT 0,
  overdue_cnt BIGINT DEFAULT 0,
  renew_cnt BIGINT DEFAULT 0,
  top_category_codes VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_reader_period (stat_date, period, reader_id),
  CONSTRAINT fk_stat_reader FOREIGN KEY (reader_id) REFERENCES reader(id)
);

