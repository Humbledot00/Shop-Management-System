-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2024 at 03:05 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shop management`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `FetchAllDataFromTable` (IN `transactions` VARCHAR(255))   BEGIN
    SET @sql = CONCAT('SELECT * FROM ', transactions);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `analytics`
--

CREATE TABLE `analytics` (
  `id` int(10) NOT NULL,
  `product_id` varchar(10) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `analytics`
--

INSERT INTO `analytics` (`id`, `product_id`, `date`) VALUES
(16, 'A020', '2024-02-27 21:13:20'),
(17, 'A014', '2024-03-02 14:01:00'),
(18, 'A037', '2024-03-12 21:34:11'),
(19, 'A028', '2024-03-12 21:46:02'),
(20, 'A027', '2024-03-02 21:48:14'),
(21, 'A011', '2024-03-01 21:56:37'),
(22, 'A012', '2024-02-28 21:59:14'),
(23, 'A011', '2024-03-02 22:04:42'),
(24, 'A015', '2024-03-01 22:05:37'),
(25, 'A014', '2024-03-02 22:23:22'),
(26, 'A015', '2024-03-03 22:34:42'),
(27, 'A011', '2024-03-04 22:43:36'),
(28, 'A011', '2024-03-05 22:44:57'),
(29, 'A011', '2024-03-06 22:45:40'),
(30, 'A011', '2024-03-07 22:45:50'),
(31, 'A013', '2024-03-02 22:48:24'),
(32, 'A011', '2024-03-08 22:54:56'),
(33, 'A013', '2024-03-09 22:55:44'),
(34, 'A011', '2024-03-11 21:21:46'),
(35, 'A016', '2024-03-25 19:30:39'),
(36, 'A015', '2024-03-25 19:31:27'),
(37, 'A015', '2024-03-25 19:32:16');

-- --------------------------------------------------------

--
-- Table structure for table `notification_log`
--

CREATE TABLE `notification_log` (
  `id` int(5) NOT NULL,
  `product_id` varchar(10) NOT NULL,
  `message` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_log`
--

INSERT INTO `notification_log` (`id`, `product_id`, `message`) VALUES
(7, 'A016', 'Product A016 quantity is below 1. Notify appropriate personnel.'),
(9, 'A015', 'Product A015 quantity is below 1. Notify appropriate personnel.');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `transaction_date` datetime NOT NULL,
  `total_bill` int(10) NOT NULL,
  `sid` varchar(5) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`transaction_date`, `total_bill`, `sid`, `id`) VALUES
('2024-02-25 19:06:29', 56, 'S001', 1),
('2024-02-25 22:00:04', 330, 'S002', 2),
('2024-03-02 22:04:42', 3200, 'S005', 5),
('2024-03-02 22:41:20', 5220, 'S002', 8),
('2024-03-02 22:46:50', 4350, 'S002', 9),
('2024-03-02 22:48:13', 1740, 'S002', 10),
('2024-03-02 22:48:24', 2610, 'S002', 11),
('2024-03-25 19:31:41', 3200, 'S005', 12);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` varchar(5) NOT NULL,
  `product_name` text NOT NULL,
  `MRP` int(5) NOT NULL,
  `quantity` int(5) NOT NULL,
  `suplier_id` varchar(5) NOT NULL,
  `wprice` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `product_name`, `MRP`, `quantity`, `suplier_id`, `wprice`) VALUES
('A011', 'Backpack', 1000, 8, 'S002', 870),
('A012', 'Pens', 15, 50, 'S001', 10),
('A013', ' Perfume', 350, 35, 'S006', 290),
('A014', 'Smart band', 1000, 5, 'S001', 940),
('A015', 'Wallet ', 400, 0, 'S005', 320),
('A016', 'Keys ', 70, 0, 'S004', 50),
('A017', 'Water bottle ', 150, 16, 'S003', 100),
('A018', 'Charger ', 270, 6, 'S006', 200),
('A019', 'Headphones ', 900, 5, 'S002', 880),
('A020', 'Sunglasses ', 550, 8, 'S007', 400),
('A021', 'Umbrella ', 350, 10, 'S007', 300),
('A022', 'Notebook ', 55, 25, 'S002', 40),
('A023', 'Hand sanitizer ', 120, 4, 'S004', 100),
('A024', 'Tissues', 50, 20, 'S005', 30),
('A025', 'Lip balm ', 30, 6, 'S004', 20),
('A026', 'Band-aids', 20, 20, 'S007', 10),
('A027', 'Mobile phone case', 200, 5, 'S003', 150),
('A028', 'Earphones', 150, 11, 'S002', 120),
('A029', 'USB cable', 100, 6, 'S004', 80),
('A030', 'Portable water filter', 1000, 6, 'S003', 940),
('A031', 'Travel mug', 100, 4, 'S002', 80),
('A032', 'Hat', 100, 16, 'S001', 50),
('A033', 'Portable fan', 250, 6, 'S001', 200),
('A034', 'Flashlight', 150, 16, 'S001', 120),
('A035', 'Hair oil', 100, 12, 'S007', 80),
('A036', 'Sunscream', 240, 10, 'S006', 200),
('A037', 'Deodorant', 250, 5, 'S002', 220),
('A038', 'Notepads', 50, 10, 'S002', 30),
('A039', 'Desk organizer', 1000, 4, 'S004', 940),
('A040', 'Reading glasses', 490, 6, 'S005', 450),
('A041', 'Yoga mat', 800, 3, 'S004', 770),
('A042', 'Jump rope', 350, 6, 'S003', 320),
('A043', 'Basic cutting board', 120, 5, 'S005', 100),
('A044', 'Indoor slippers', 430, 12, 'S007', 400),
('A045', 'Desk lamp', 400, 7, 'S002', 350),
('A046', 'Sticky notes', 30, 25, 'S006', 20),
('A047', 'Mouse pad', 260, 6, 'S006', 230),
('A048', 'Toothpaste', 50, 15, 'S003', 49),
('A049', 'Soap', 40, 25, 'S001', 39),
('A050', 'Shampoo', 200, 12, 'S005', 196),
('A051', 'Conditioner', 220, 8, 'S002', 216),
('A052', 'Toilet paper', 60, 20, 'S004', 59),
('A053', 'Paper towels', 70, 30, 'S006', 69),
('A054', 'Laundry detergent', 300, 18, 'S001', 294),
('A055', 'Dish soap', 80, 5, 'S003', 78),
('A056', 'Trash bags', 150, 10, 'S002', 147),
('A057', 'Aluminum foil', 100, 22, 'S005', 98),
('A058', 'Plastic wrap', 80, 17, 'S004', 78),
('A059', 'Light bulbs', 120, 28, 'S006', 118),
('A060', 'Batteries', 80, 14, 'S001', 78),
('A061', 'Candles', 50, 3, 'S003', 49),
('A062', 'Matches', 20, 9, 'S005', 20),
('A063', 'Bandages', 30, 6, 'S002', 29),
('A064', 'Pain relievers (e.g., aspirin)', 50, 27, 'S004', 49),
('A065', 'Cold medicine', 100, 19, 'S006', 98),
('A066', 'Allergy medicine', 120, 11, 'S001', 118),
('A067', 'Hand sanitizer', 50, 29, 'S003', 49),
('A068', 'Tissues', 60, 4, 'S005', 59),
('A069', 'Cotton swabs', 40, 16, 'S002', 39),
('A070', 'Dishwashing gloves', 80, 23, 'S004', 78),
('A071', 'Sponges', 30, 7, 'S006', 29),
('A072', 'Rice', 80, 15, 'S003', 78),
('A073', 'Wheat flour', 50, 25, 'S001', 49),
('A074', 'Lentils', 120, 12, 'S005', 117),
('A075', 'Turmeric', 30, 8, 'S002', 29),
('A076', 'Cumin', 40, 20, 'S004', 39),
('A077', 'Coriander', 25, 30, 'S006', 24),
('A078', 'Mustard oil', 150, 18, 'S001', 147),
('A079', 'Sunflower oil', 120, 5, 'S003', 118),
('A080', 'Tea leaves', 70, 10, 'S002', 68),
('A081', 'Sugar', 40, 22, 'S005', 39),
('A082', 'Salt', 20, 17, 'S004', 19),
('A083', 'Milk', 50, 28, 'S006', 49),
('A084', 'Yogurt', 30, 14, 'S001', 29),
('A085', 'Potatoes', 40, 3, 'S003', 39),
('A086', 'Onions', 20, 9, 'S005', 19),
('A087', 'Tomatoes', 25, 6, 'S002', 24),
('A088', 'Bananas', 20, 27, 'S004', 19),
('A089', 'Apples', 60, 19, 'S006', 58),
('A090', 'Oranges', 50, 11, 'S001', 49),
('A091', 'Bread', 30, 29, 'S003', 29),
('A092', 'Eggs', 60, 4, 'S005', 58),
('A093', 'Chicken', 120, 16, 'S002', 118),
('A094', 'Fish', 150, 23, 'S004', 147),
('A095', 'Paneer', 100, 7, 'S006', 98),
('A096', 'Garam masala', 40, 10, 'S001', 39),
('A097', 'Curry powder', 30, 23, 'S003', 29),
('A098', 'Pickles', 50, 7, 'S005', 49),
('A099', 'Namkeen', 40, 11, 'S002', 39),
('A100', 'Biscuits', 20, 18, 'S004', 19),
('A101', 'Screws', 20, 15, 'S003', 19),
('A102', 'Nails', 30, 25, 'S001', 29),
('A103', 'Screwdriver set', 150, 12, 'S005', 147),
('A104', 'Hammer', 100, 8, 'S002', 98),
('A105', 'Wrench set', 200, 20, 'S004', 196),
('A106', 'Drill machine', 1000, 30, 'S006', 980),
('A107', 'Measuring tape', 50, 18, 'S001', 49),
('A108', 'Pliers', 80, 5, 'S003', 78),
('A109', 'Paintbrush set', 120, 10, 'S002', 117),
('A110', 'Paint roller', 70, 22, 'S005', 68),
('A111', 'Sandpaper pack', 40, 17, 'S004', 39),
('A112', 'Safety goggles', 60, 28, 'S006', 58),
('A113', 'Gloves', 30, 14, 'S001', 29),
('A114', 'Caulking gun', 80, 3, 'S003', 78),
('A115', 'Ladder', 500, 9, 'S005', 490),
('A116', 'Extension cord', 100, 6, 'S002', 98),
('A117', 'Adhesive tape', 20, 27, 'S004', 19),
('A118', 'Door lock', 150, 19, 'S006', 147),
('A119', 'Hinge set', 120, 11, 'S001', 117),
('A120', 'Saw', 200, 29, 'S003', 196);

--
-- Triggers `product`
--
DELIMITER $$
CREATE TRIGGER `delete_from_notification_log_trigger` AFTER UPDATE ON `product` FOR EACH ROW BEGIN
    DECLARE product_qty INT;

    -- Get the quantity of the corresponding product in the product table
    SELECT quantity INTO product_qty FROM product WHERE product_id = NEW.product_id;

    -- Check if the product quantity is greater than 0 and the product_id exists in the notification_log
    IF product_qty > 0 THEN
        DELETE FROM notification_log WHERE product_id = NEW.product_id;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `product_quantity_trigger` AFTER UPDATE ON `product` FOR EACH ROW BEGIN
    IF NEW.quantity < 1 THEN
        INSERT INTO notification_log (product_id, message)
        VALUES (NEW.product_id, CONCAT('Product ', NEW.product_id, ' quantity is below 1. Notify appropriate personnel.'));
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `supplier_id` varchar(5) NOT NULL,
  `supplier_name` text NOT NULL,
  `contact` bigint(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `supplier_name`, `contact`) VALUES
('S001', 'Ramesha', 8745447843),
('S002', 'Girisha', 7456987454),
('S003', 'Sooraj', 9678657832),
('S004', 'Gangadhar', 8758657865),
('S005', 'Ramesh', 9845657854),
('S006', 'Madhav', 7478657853),
('S007', 'Govindha', 8762345790);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `totalBill` float NOT NULL,
  `transactionDate` datetime NOT NULL,
  `totalwprice` int(10) NOT NULL,
  `action` varchar(10) NOT NULL,
  `id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`totalBill`, `transactionDate`, `totalwprice`, `action`, `id`) VALUES
(600, '2024-02-27 21:13:20', 490, 'earned', 48),
(5000, '2024-03-02 14:01:00', 4350, 'earned', 49),
(2000, '2024-03-12 21:34:11', 1740, 'earned', 51),
(8000, '2024-03-12 21:46:02', 6960, 'earned', 52),
(2400, '2024-03-02 21:48:14', 1920, 'earned', 53),
(10000, '2024-03-01 21:56:37', 8700, 'earned', 55),
(4000, '2024-02-28 21:59:14', 3200, 'earned', 56),
(0, '2024-03-02 22:04:42', 3200, 'spent', 57),
(5000, '2024-03-01 22:05:37', 4350, 'earned', 59),
(1990, '2024-03-02 22:23:22', 1740, 'earned', 61),
(6000, '2024-03-03 22:34:42', 5220, 'earned', 62),
(2000, '2024-03-04 22:43:36', 1740, 'earned', 64),
(1000, '2024-03-05 22:44:57', 870, 'earned', 65),
(1000, '2024-03-06 22:45:40', 870, 'earned', 66),
(1000, '2024-03-07 22:45:50', 1740, 'earned', 67),
(0, '2024-03-02 22:48:24', 2610, 'spent', 70),
(1050, '2024-03-08 22:54:56', 870, 'earned', 71),
(350, '2024-03-09 22:55:44', 290, 'earned', 72),
(900, '2024-03-11 21:21:46', 870, 'earned', 73),
(420, '2024-03-25 19:30:39', 300, 'earned', 74),
(4000, '2024-03-25 19:31:27', 3200, 'earned', 75),
(0, '2024-03-25 19:31:41', 3200, 'spent', 76),
(4000, '2024-03-25 19:32:16', 3200, 'earned', 77);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `analytics`
--
ALTER TABLE `analytics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `notification_log`
--
ALTER TABLE `notification_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sid` (`sid`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `suplier_id` (`suplier_id`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `analytics`
--
ALTER TABLE `analytics`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `notification_log`
--
ALTER TABLE `notification_log`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `analytics`
--
ALTER TABLE `analytics`
  ADD CONSTRAINT `analytics_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `supplier` (`supplier_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`suplier_id`) REFERENCES `supplier` (`supplier_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
