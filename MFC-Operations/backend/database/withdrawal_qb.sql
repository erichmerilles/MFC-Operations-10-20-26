-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 21, 2026 at 08:37 AM
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
-- Database: `withdrawal_qb`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(80) NOT NULL,
  `entity_type` varchar(80) NOT NULL,
  `entity_id` bigint(20) UNSIGNED DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `employee_id`, `action`, `entity_type`, `entity_id`, `details`, `ip_address`, `created_at`) VALUES
(1, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-13 08:50:48'),
(2, 1, 'LOGIN', 'employee', 1, 'Successful login', '192.168.1.134', '2026-10-13 08:52:28'),
(3, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-13 09:10:07'),
(4, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-13 09:10:12'),
(5, 1, 'CREATE', 'withdrawal', 1, 'Saved withdrawal 2026-101001 with 1 line(s)', '::1', '2026-10-13 09:12:04'),
(6, 1, 'CREATE', 'withdrawal', 2, 'Saved withdrawal 2026-101002 with 2 line(s)', '::1', '2026-10-13 09:59:41'),
(7, 1, 'SAVE_DRAFT', 'invoice', 2, 'Saved invoice draft for 2026-101002 with 2 line(s)', '::1', '2026-10-13 10:00:54'),
(8, 1, 'CREATE', 'withdrawal', 3, 'Saved withdrawal 2026-101003 with 1 line(s)', '::1', '2026-10-13 10:05:42'),
(9, 1, 'CREATE', 'withdrawal', 4, 'Saved withdrawal 2026-101004 with 2 line(s)', '::1', '2026-10-13 10:16:42'),
(10, 1, 'UPDATE', 'withdrawal', 4, 'Saved withdrawal 2026-101004 with 3 line(s)', '::1', '2026-10-13 10:19:10'),
(11, 1, 'UPDATE', 'withdrawal', 3, 'Saved withdrawal 2026-101003 with 2 line(s)', '::1', '2026-10-13 10:19:34'),
(12, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-13 10:21:17'),
(13, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-13 10:21:25'),
(14, 1, 'CREATE', 'employee', 2, 'Created employee john as Employee', '::1', '2026-10-13 10:36:47'),
(15, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-13 10:37:09'),
(16, 1, 'CREATE', 'withdrawal', 5, 'Saved withdrawal 2026-101005 with 1 line(s)', '::1', '2026-10-13 10:47:21'),
(17, 1, 'CREATE', 'product', 5, 'Created product LUTOSA', '::1', '2026-10-13 11:29:23'),
(18, 1, 'CREATE', 'withdrawal', 6, 'Saved withdrawal 2026-101006 with 1 line(s)', '::1', '2026-10-13 11:30:00'),
(19, 1, 'UPDATE', 'withdrawal', 6, 'Saved withdrawal 2026-101006 with 1 line(s)', '::1', '2026-10-13 11:36:58'),
(20, 1, 'UPDATE', 'withdrawal', 6, 'Saved withdrawal 2026-101006 with 1 line(s)', '::1', '2026-10-13 11:37:10'),
(21, 1, 'UPDATE', 'withdrawal', 6, 'Saved withdrawal 2026-101006 with 1 line(s)', '::1', '2026-10-13 11:37:21'),
(22, 1, 'UPDATE', 'product', 1, 'Updated product CHICKEN POPPERS', '::1', '2026-10-13 11:48:27'),
(23, 1, 'UPDATE', 'product', 4, 'Updated product BEEF PATTY', '::1', '2026-10-13 11:48:33'),
(24, 2, 'LOGOUT', 'employee', 2, 'User signed out', '::1', '2026-10-13 11:51:00'),
(25, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-13 11:51:33'),
(26, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-14 08:16:37'),
(27, 1, 'UPDATE', 'withdrawal', 6, 'Saved withdrawal 2026-101006 with 1 line(s)', '::1', '2026-10-14 12:57:07'),
(28, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-14 12:59:48'),
(29, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-14 12:59:54'),
(30, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-14 13:00:08'),
(31, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-14 13:01:20'),
(32, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-14 13:01:37'),
(33, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 07:46:07'),
(34, 1, 'UPDATE', 'product', 5, 'Updated product LUTOSA', '::1', '2026-10-15 07:49:03'),
(35, 1, 'UPDATE', 'product', 5, 'Updated product LUTOSA', '::1', '2026-10-15 08:05:43'),
(36, 1, 'UPDATE', 'client', 1, 'Updated client Sample Client A', '::1', '2026-10-15 08:05:52'),
(37, 1, 'UPDATE', 'client', 1, 'Updated client Sample Client A', '::1', '2026-10-15 08:05:56'),
(38, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-15 08:09:12'),
(39, 1, 'UPDATE', 'product', 1, 'Updated product CHICKEN POPPERS', '::1', '2026-10-15 08:27:50'),
(40, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-15 09:27:43'),
(41, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 09:42:23'),
(42, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-15 09:43:49'),
(43, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 09:46:10'),
(44, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-15 09:46:24'),
(45, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 09:46:59'),
(46, 1, 'UPDATE', 'product', 1, 'Updated product CHICKEN POPPERS 200g', '::1', '2026-10-15 09:47:48'),
(47, 1, 'UPDATE', 'product', 1, 'Updated product CHICKEN POPPERS 200g', '::1', '2026-10-15 09:48:08'),
(48, 1, 'CREATE', 'withdrawal', 7, 'Saved withdrawal 2026-101007 with 2 line(s)', '::1', '2026-10-15 09:49:16'),
(49, 1, 'UPDATE', 'product', 5, 'Updated product LUTOSA', '::1', '2026-10-15 09:54:00'),
(50, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-15 10:19:45'),
(51, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 10:22:22'),
(52, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-15 10:27:31'),
(53, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 10:27:36'),
(54, 2, 'LOGOUT', 'employee', 2, 'User signed out', '::1', '2026-10-15 10:27:46'),
(55, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-15 10:27:54'),
(56, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-15 11:00:28'),
(57, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 12:28:41'),
(58, 1, 'CREATE', 'withdrawal', 8, 'Saved withdrawal 2026-101008 with 1 line(s)', '::1', '2026-10-15 12:39:40'),
(59, 1, 'SAVE_DRAFT', 'invoice', 8, 'Saved invoice draft for 2026-101008 with 1 line(s)', '::1', '2026-10-15 12:40:35'),
(60, 1, 'UPDATE', 'client', 1, 'Updated client Puregold', '::1', '2026-10-15 12:50:39'),
(61, 1, 'UPDATE', 'client', 2, 'Updated client SM', '::1', '2026-10-15 12:50:46'),
(62, 1, 'UPDATE', 'client', 3, 'Updated client Alfamart', '::1', '2026-10-15 12:50:55'),
(63, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 13:34:43'),
(64, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-15 13:34:49'),
(65, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-15 13:35:13'),
(66, 1, 'DELETE', 'product', 4, 'Permanently deleted unused product', '::1', '2026-10-15 14:31:58'),
(67, 1, 'DELETE', 'product', 5, 'Permanently deleted unused product', '::1', '2026-10-15 14:33:15'),
(68, 1, 'DELETE', 'product', 1, 'Permanently deleted unused product', '::1', '2026-10-15 14:33:29'),
(69, 1, 'DELETE', 'product', 2, 'Permanently deleted unused product', '::1', '2026-10-15 14:33:41'),
(70, 1, 'CREATE', 'product', 458, 'Created product POTATO NOISETTES', '::1', '2026-10-15 15:05:42'),
(71, 1, 'CREATE', 'product', 459, 'Created product 10/10 FS CAJUN', '::1', '2026-10-15 15:07:30'),
(72, 1, 'DEACTIVATE', 'product', 459, 'Updated product 10/10 FS CAJUN', '::1', '2026-10-15 15:07:39'),
(73, 1, 'CREATE', 'product', 460, 'Created product 10/10 STRAIGHTCUT XTRA CRISPY', '::1', '2026-10-15 15:13:17'),
(74, 1, 'CREATE', 'product', 461, 'Created product 7/7 FINEST SHOESTRING XTRA CRISPY', '::1', '2026-10-15 15:18:12'),
(75, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-16 07:52:21'),
(76, 1, 'UPDATE', 'product', 460, 'Updated product 10/10 STRAIGHTCUT XTRA CRISPY', '::1', '2026-10-16 07:53:19'),
(77, 1, 'UPDATE', 'product', 461, 'Updated product 7/7 FINEST SHOESTRING XTRA CRISPY', '::1', '2026-10-16 07:53:23'),
(78, 1, 'CREATE', 'product', 462, 'Created product 10/10 STRAIGHTCUT SKIN-ON', '::1', '2026-10-16 08:06:28'),
(79, 1, 'CREATE', 'product', 463, 'Created product 14/14 THICK CUT FRIES', '::1', '2026-10-16 08:07:12'),
(80, 1, 'CREATE', 'product', 464, 'Created product 5/5 SKINNY SKIN-ON', '::1', '2026-10-16 08:09:41'),
(81, 1, 'CREATE', 'product', 465, 'Created product CRUNCHY HASH BROWN', '::1', '2026-10-16 08:11:02'),
(82, 1, 'CREATE', 'product', 466, 'Created product CRUNCHY OVAL HASH BROWN', '::1', '2026-10-16 08:11:52'),
(83, 1, 'CREATE', 'product', 467, 'Created product MASHED POTATO', '::1', '2026-10-16 08:13:10'),
(84, 1, 'CREATE', 'product', 468, 'Created product SPICY WEDGES', '::1', '2026-10-16 08:14:38'),
(85, 1, 'CREATE', 'product', 469, 'Created product POTATO WEDGES', '::1', '2026-10-16 08:15:05'),
(86, 1, 'CREATE', 'product', 470, 'Created product CRINKLE CUT', '::1', '2026-10-16 08:16:02'),
(87, 1, 'UPDATE', 'product', 504, 'Updated product 10/10 CLASSIC CUT FRIES 1KG', '::1', '2026-10-16 08:23:01'),
(88, 1, 'UPDATE', 'product', 552, 'Updated product 10/10 CRISPY COATED 6X2KG', '::1', '2026-10-16 08:30:28'),
(89, 1, 'DEACTIVATE', 'product', 473, 'Updated product 10/10 FS CAJUN', '::1', '2026-10-16 08:31:01'),
(90, 1, 'UPDATE', 'product', 512, 'Updated product 10/10 STRAIGHTCUT 2KG CHINA', '::1', '2026-10-16 08:32:04'),
(91, 1, 'UPDATE', 'product', 476, 'Updated product 10/10 STRAIGHTCUT SKIN-ON', '::1', '2026-10-16 08:33:02'),
(92, 1, 'UPDATE', 'product', 552, 'Updated product 10/10 CRISPY COATED 6X2KG', '::1', '2026-10-16 08:40:14'),
(93, 1, 'UPDATE', 'product', 474, 'Updated product 10/10 STRAIGHTCUT XTRA CRISPY', '::1', '2026-10-16 08:41:17'),
(94, 1, 'UPDATE', 'product', 502, 'Updated product 10/18 STEAK FRIES 2.5KG', '::1', '2026-10-16 08:41:50'),
(95, 1, 'UPDATE', 'product', 545, 'Updated product 12/12 CRINKLE CUT CHINA 10X1KG', '::1', '2026-10-16 08:42:07'),
(96, 1, 'UPDATE', 'product', 540, 'Updated product 13/13 STRAIGHTCUT', '::1', '2026-10-16 08:43:04'),
(97, 1, 'UPDATE', 'product', 477, 'Updated product 14/14 THICK CUT FRIES', '::1', '2026-10-16 08:46:25'),
(98, 1, 'UPDATE', 'product', 478, 'Updated product 5/5 SKINNY SKIN-ON', '::1', '2026-10-16 08:48:02'),
(99, 1, 'UPDATE', 'product', 551, 'Updated product 7/7 CRISPY COATED 6X2KG', '::1', '2026-10-16 08:50:19'),
(100, 1, 'DEACTIVATE', 'product', 471, 'Updated product 7/7 SHOESTRING 1 KILO', '::1', '2026-10-16 08:57:53'),
(101, 1, 'UPDATE', 'product', 533, 'Updated product 7/7 SHOESTRING 1 KILO NEW PACK', '::1', '2026-10-16 08:58:32'),
(102, 1, 'UPDATE', 'product', 487, 'Updated product 7/7 SHOESTRING 2 KILO CHINA', '::1', '2026-10-16 08:59:52'),
(103, 1, 'UPDATE', 'product', 486, 'Updated product 7/7 THIN CUT SHOESTRING', '::1', '2026-10-16 09:04:17'),
(104, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-16 09:06:32'),
(105, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-16 09:06:46'),
(106, 1, 'UPDATE', 'product', 516, 'Updated product 7/7 THINCUT SHOESTRING 24x400g', '::1', '2026-10-16 09:08:17'),
(107, 1, 'UPDATE', 'product', 542, 'Updated product CHICKEN BREAST CHUNKS 1KG', '::1', '2026-10-16 09:09:10'),
(108, 1, 'UPDATE', 'product', 494, 'Updated product WHITE FISHBALL 500gx24', '::1', '2026-10-16 09:20:44'),
(109, 1, 'UPDATE', 'product', 511, 'Updated product SWEET POTATO', '::1', '2026-10-16 09:21:37'),
(110, 1, 'UPDATE', 'product', 539, 'Updated product SQUID INK CALAMARI RING', '::1', '2026-10-16 09:25:02'),
(111, 1, 'UPDATE', 'product', 526, 'Updated product SPINACH BALL 20 X 500G', '::1', '2026-10-16 09:26:17'),
(112, 1, 'UPDATE', 'product', 491, 'Updated product SPICY WEDGES 750G', '::1', '2026-10-16 09:27:35'),
(113, 1, 'UPDATE', 'product', 491, 'Updated product SPICY WEDGES 750G', '::1', '2026-10-16 09:29:04'),
(114, 1, 'UPDATE', 'product', 482, 'Updated product SPICY WEDGES', '::1', '2026-10-16 09:29:34'),
(115, 1, 'UPDATE', 'product', 543, 'Updated product SHREDDED CHICKEN 1KG', '::1', '2026-10-16 09:30:25'),
(116, 1, 'UPDATE', 'product', 492, 'Updated product SEA URCHIN 190G X 40', '::1', '2026-10-16 09:32:09'),
(117, 1, 'UPDATE', 'product', 507, 'Updated product SAVEMORE 2KG', '::1', '2026-10-16 09:32:39'),
(118, 1, 'UPDATE', 'product', 506, 'Updated product SAVEMORE 1KG', '::1', '2026-10-16 09:34:01'),
(119, 1, 'UPDATE', 'product', 493, 'Updated product SALMON FLAVOURED 175G X 40', '::1', '2026-10-16 09:34:46'),
(120, 1, 'UPDATE', 'product', 528, 'Updated product RUSTIC POTATO SLICES 2.5KG', '::1', '2026-10-16 09:35:06'),
(121, 1, 'UPDATE', 'product', 527, 'Updated product ROSTIS WITH ONION TASTE 1 KG', '::1', '2026-10-16 09:36:29'),
(122, 1, 'UPDATE', 'product', 520, 'Updated product PRAWN FLAVOURED BALL', '::1', '2026-10-16 09:38:14'),
(123, 1, 'UPDATE', 'product', 483, 'Updated product POTATO WEDGES', '::1', '2026-10-16 09:40:22'),
(124, 1, 'UPDATE', 'product', 513, 'Updated product POTATO NOISETTES 750G', '::1', '2026-10-16 09:40:49'),
(125, 1, 'UPDATE', 'product', 472, 'Updated product POTATO NOISETTES', '::1', '2026-10-16 09:41:04'),
(126, 1, 'UPDATE', 'product', 534, 'Updated product POTATO FLAKES 10X1KG', '::1', '2026-10-16 09:41:19'),
(127, 1, 'UPDATE', 'product', 490, 'Updated product POTATO CRUNCHIES', '::1', '2026-10-16 09:41:36'),
(128, 1, 'UPDATE', 'product', 514, 'Updated product POTATO CROQUETTES 750G', '::1', '2026-10-16 09:42:01'),
(129, 1, 'UPDATE', 'product', 535, 'Updated product NATURAL CUT ONION RING', '::1', '2026-10-16 09:42:34'),
(130, 1, 'UPDATE', 'product', 564, 'Updated product MIXED VEGGIES 2WAY', '::1', '2026-10-16 09:43:46'),
(131, 1, 'UPDATE', 'product', 508, 'Updated product MIXED VEGGIES 20x500g', '::1', '2026-10-16 09:44:08'),
(132, 1, 'UPDATE', 'product', 544, 'Updated product MIXED VEGGIES 10X1KG', '::1', '2026-10-16 09:44:25'),
(133, 1, 'UPDATE', 'product', 510, 'Updated product MIXED BERRIES', '::1', '2026-10-16 09:44:48'),
(134, 1, 'UPDATE', 'product', 481, 'Updated product MASHED POTATO', '::1', '2026-10-16 09:45:37'),
(135, 1, 'UPDATE', 'product', 503, 'Updated product KRISSPY CRINKLE CUT 1KG', '::1', '2026-10-16 09:45:57'),
(136, 1, 'UPDATE', 'product', 529, 'Updated product KOREAN STYLE FISHCAKE', '::1', '2026-10-16 09:46:19'),
(137, 1, 'UPDATE', 'product', 489, 'Updated product KDHY 7/7 SHOESTRING 2KG', '::1', '2026-10-16 09:46:39'),
(138, 1, 'UPDATE', 'product', 521, 'Updated product JUMBO FISH BEAN CURD 350g', '::1', '2026-10-16 09:47:03'),
(139, 1, 'UPDATE', 'product', 497, 'Updated product JAPANESE FISH TOFU 160gx40', '::1', '2026-10-16 09:47:21'),
(140, 1, 'UPDATE', 'product', 515, 'Updated product HASH BROWN MINI 4 X 2.5 KG', '::1', '2026-10-16 09:50:35'),
(141, 1, 'UPDATE', 'product', 550, 'Updated product GRILLED TENDER CHUNKS 200GX25', '::1', '2026-10-16 09:50:57'),
(142, 1, 'UPDATE', 'product', 557, 'Updated product GC PAPER WRAPPED CHICKEN 240GX40', '::1', '2026-10-16 09:51:38'),
(143, 1, 'UPDATE', 'product', 556, 'Updated product GC PANDAN CHICKEN 240GX40', '::1', '2026-10-16 09:51:57'),
(144, 1, 'UPDATE', 'product', 555, 'Updated product GC HERITAGE CHICKEN 200X40', '::1', '2026-10-16 09:52:16'),
(145, 1, 'UPDATE', 'product', 554, 'Updated product GC HERB SALAD 100GX50', '::1', '2026-10-16 09:52:31'),
(146, 1, 'UPDATE', 'product', 558, 'Updated product GC HAINANESE 190g x48', '::1', '2026-10-16 09:52:47'),
(147, 1, 'UPDATE', 'product', 561, 'Updated product GC GRILLED BBQ MD 300GX24', '::1', '2026-10-16 09:53:06'),
(148, 1, 'UPDATE', 'product', 479, 'Updated product CRUNCHY HASH BROWN', '::1', '2026-10-16 09:53:29'),
(149, 1, 'UPDATE', 'product', 484, 'Updated product CRINKLE CUT', '::1', '2026-10-16 09:53:42'),
(150, 1, 'UPDATE', 'product', 549, 'Updated product CLASSIC FRIED CHICKEN 600G X 16', '::1', '2026-10-16 09:53:58'),
(151, 1, 'UPDATE', 'product', 546, 'Updated product CHICKEN SHREDDED 250G X 40', '::1', '2026-10-16 09:55:19'),
(152, 1, 'UPDATE', 'product', 541, 'Updated product CHICKEN POPPIN\' BITES 500G', '::1', '2026-10-16 09:55:31'),
(153, 1, 'UPDATE', 'product', 548, 'Updated product CHICKEN POPPIN\' BITES 200G X 25', '::1', '2026-10-16 09:55:46'),
(154, 1, 'UPDATE', 'product', 547, 'Updated product CHICKEN CHUNKS 250G X 40', '::1', '2026-10-16 09:56:04'),
(155, 1, 'UPDATE', 'product', 509, 'Updated product CALIFORNIA MIXED', '::1', '2026-10-16 09:56:26'),
(156, 1, 'UPDATE', 'product', 560, 'Updated product BTS NEW ORLEANS MIDDLE WING 24X300G', '::1', '2026-10-16 09:56:56'),
(157, 1, 'UPDATE', 'product', 563, 'Updated product BTS CRISPY CHICKEN SKIN 24X300G', '::1', '2026-10-16 09:57:12'),
(158, 1, 'UPDATE', 'product', 559, 'Updated product BTS BUFFALO MIDDLE WINGS 24X300G', '::1', '2026-10-16 09:57:24'),
(159, 1, 'UPDATE', 'product', 538, 'Updated product BREADER MOZZARELLA CHEESE', '::1', '2026-10-16 09:57:38'),
(160, 1, 'UPDATE', 'product', 536, 'Updated product BREADED JALAPENO WITH CHEESE', '::1', '2026-10-16 09:57:50'),
(161, 1, 'UPDATE', 'product', 525, 'Updated product BLUEBERRY 20 X 500G', '::1', '2026-10-16 09:59:16'),
(162, 1, 'UPDATE', 'product', 519, 'Updated product BEEF BALL W/ MOZZA 300g', '::1', '2026-10-16 09:59:38'),
(163, 1, 'UPDATE', 'product', 537, 'Updated product BATTERED ONION RING', '::1', '2026-10-16 09:59:51'),
(164, 1, 'UPDATE', 'product', 502, 'Updated product 10/18 STEAK FRIES 2.5KG', '::1', '2026-10-16 10:22:01'),
(165, 1, 'CREATE', 'withdrawal', 9, 'Saved withdrawal 2026-101001 with 1 line(s)', '::1', '2026-10-16 10:30:44'),
(166, 1, 'UPDATE', 'withdrawal', 9, 'Saved withdrawal 2026-101001 with 1 line(s)', '::1', '2026-10-16 10:34:14'),
(167, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-16 10:49:04'),
(168, 1, 'UPDATE', 'product', 562, 'Updated product GC GARLICKY ADOBO MD 300G X 24', '::1', '2026-10-16 11:14:41'),
(169, 1, 'UPDATE', 'product', 553, 'Updated product GC GARLICKY ADOBO 200GX40', '::1', '2026-10-16 11:15:23'),
(170, 1, 'UPDATE', 'product', 485, 'Updated product FROZEN KERNEL CORN', '::1', '2026-10-16 11:16:28'),
(171, 1, 'UPDATE', 'product', 518, 'Updated product FROZEN STRAWBERRY', '::1', '2026-10-16 11:17:52'),
(172, 1, 'CREATE', 'withdrawal', 10, 'Saved withdrawal 2026-101050 with 2 line(s)', '::1', '2026-10-16 11:27:15'),
(173, 1, 'UPDATE', 'withdrawal', 9, 'Saved withdrawal 2026-101001 with 1 line(s)', '::1', '2026-10-16 11:28:48'),
(174, 1, 'UPDATE', 'withdrawal', 9, 'Saved withdrawal 2026-101001 with 1 line(s)', '::1', '2026-10-16 11:37:49'),
(175, 1, 'UPDATE', 'withdrawal', 9, 'Saved withdrawal 2026-101001 with 1 line(s)', '::1', '2026-10-16 11:38:17'),
(176, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-16 13:58:59'),
(177, 1, 'GRANT', 'employee_permission', 2, 'Granted manage_products_sites to john', '::1', '2026-10-16 14:01:23'),
(178, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-16 14:01:34'),
(179, 1, 'REVOKE', 'employee_permission', 2, 'Revoked manage_products_sites from john', '::1', '2026-10-16 14:01:46'),
(180, 1, 'REVOKE', 'employee_permission', 2, 'Revoked manage_products_sites from john', '::1', '2026-10-16 14:01:49'),
(181, 2, 'UPDATE', 'withdrawal', 9, 'Saved withdrawal 2026-101001 with 1 line(s)', '::1', '2026-10-16 14:11:00'),
(182, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-17 07:29:08'),
(183, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-17 07:53:58'),
(184, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-17 07:56:44'),
(185, 1, 'SAVE_DRAFT', 'invoice', 9, 'Saved invoice draft for 2026-101001 with 1 line(s)', '::1', '2026-10-17 08:22:29'),
(186, 1, 'UPDATE', 'product', 533, 'Updated product 7/7 SHOESTRING 1 KILO NEW PACK', '::1', '2026-10-17 08:50:49'),
(187, 1, 'UPDATE', 'product', 550, 'Updated product GRILLED TENDER CHUNKS 200GX25', '::1', '2026-10-17 08:51:03'),
(188, 1, 'CREATE', 'withdrawal', 11, 'Saved withdrawal 2026-101002 with 2 line(s)', '::1', '2026-10-17 08:51:44'),
(189, 1, 'SAVE_DRAFT', 'invoice', 10, 'Saved invoice draft for 2026-101002 with 2 line(s)', '::1', '2026-10-17 08:52:32'),
(190, 1, 'SAVE_DRAFT', 'invoice', 10, 'Saved invoice draft for 2026-101002 with 2 line(s)', '::1', '2026-10-17 08:55:33'),
(191, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-17 13:26:17'),
(192, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-17 13:26:57'),
(193, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-19 07:53:44'),
(194, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-19 08:04:20'),
(195, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-19 09:14:13'),
(196, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-19 09:14:36'),
(197, 2, 'LOGOUT', 'employee', 2, 'User signed out', '::1', '2026-10-19 09:58:21'),
(198, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-19 10:06:19'),
(199, 2, 'LOGOUT', 'employee', 2, 'User signed out', '::1', '2026-10-19 10:15:13'),
(200, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-19 10:17:19'),
(201, 2, 'LOGOUT', 'employee', 2, 'User signed out', '::1', '2026-10-19 10:18:19'),
(202, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-19 10:18:24'),
(203, 1, 'UPDATE', 'client', 2, 'Updated client SM', '::1', '2026-10-19 10:18:30'),
(204, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-19 10:18:43'),
(205, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-19 10:18:48'),
(206, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-19 10:55:34'),
(207, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-19 10:56:58'),
(208, 1, 'UPDATE', 'site', 2, 'Updated site Branch A', '::1', '2026-10-19 11:05:02'),
(209, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-20 07:54:00'),
(210, 1, 'CREATE', 'withdrawal', 12, 'Saved withdrawal 2026-101003 with 1 line(s)', '::1', '2026-10-20 09:46:47'),
(211, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-20 09:51:54'),
(212, 1, 'CREATE', 'withdrawal', 13, 'Saved withdrawal 2026-101175 with 1 line(s)', '::1', '2026-10-20 09:52:56'),
(213, 1, 'UPDATE', 'site', 2, 'Updated site High Tower', '::1', '2026-10-20 09:55:09'),
(214, 1, 'UPDATE', 'site', 3, 'Updated site Columbia Fruit Traders', '::1', '2026-10-20 09:56:36'),
(215, 1, 'UPDATE', 'site', 1, 'Updated site Drop Ship', '::1', '2026-10-20 09:56:50'),
(216, 1, 'UPDATE', 'site', 2, 'Updated site High Tower Cold Storage', '::1', '2026-10-20 09:57:08'),
(217, 1, 'CREATE', 'site', 4, 'Created site Met Food Office', '::1', '2026-10-20 09:57:21'),
(218, 1, 'CREATE', 'site', 5, 'Created site Polar Bear Freezing & Storage C', '::1', '2026-10-20 09:58:02'),
(219, 1, 'CREATE', 'site', 6, 'Created site QC Warehouse', '::1', '2026-10-20 09:58:12'),
(220, 1, 'CREATE', 'site', 7, 'Created site Toplis Logistics Inc', '::1', '2026-10-20 09:58:30'),
(221, 1, 'UPDATE', 'client', 26, 'Updated client VIKINGS', '::1', '2026-10-20 10:09:03'),
(222, 2, 'LOGIN', 'employee', 2, 'Successful login', '192.168.1.134', '2026-10-20 10:16:10'),
(223, 1, 'CREATE', 'employee', 3, 'Created employee mfc-allen as Employee', '::1', '2026-10-20 10:19:19'),
(224, 3, 'LOGIN', 'employee', 3, 'Successful login', '192.168.1.45', '2026-10-20 10:20:55'),
(225, 3, 'CREATE', 'withdrawal', 14, 'Saved withdrawal 2026-101176 with 1 line(s)', '192.168.1.45', '2026-10-20 10:21:25'),
(226, 3, 'LOGOUT', 'employee', 3, 'User signed out', '192.168.1.45', '2026-10-20 10:22:36'),
(227, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-20 11:49:54'),
(228, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-20 11:50:00'),
(229, 1, 'UPDATE', 'client', 3, 'Updated client Alfamart', '::1', '2026-10-20 11:51:28'),
(230, 1, 'DEACTIVATE', 'site', 6, 'Updated site QC Warehouse', '::1', '2026-10-20 11:53:11'),
(231, 1, 'DEACTIVATE', 'site', 5, 'Updated site Polar Bear Freezing & Storage C', '::1', '2026-10-20 11:53:17'),
(232, 1, 'LOGOUT', 'employee', 1, 'User signed out', '::1', '2026-10-20 12:47:27'),
(233, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-20 12:51:10'),
(234, 2, 'LOGOUT', 'employee', 2, 'User signed out', '::1', '2026-10-20 12:51:13'),
(235, 2, 'LOGIN', 'employee', 2, 'Successful login', '::1', '2026-10-20 12:51:19'),
(236, 2, 'LOGOUT', 'employee', 2, 'User signed out', '::1', '2026-10-20 14:14:43'),
(237, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-21 07:54:00'),
(238, 2, 'LOGIN', 'employee', 2, 'Successful login', '192.168.1.134', '2026-10-21 08:08:22'),
(239, 1, 'CREATE', 'withdrawal', 15, 'Saved withdrawal 2026-101175 with 1 line(s)', '::1', '2026-10-21 08:45:06'),
(240, 1, 'UPDATE', 'withdrawal', 15, 'Saved withdrawal 2026-101175 with 1 line(s)', '::1', '2026-10-21 08:46:11'),
(241, 1, 'UPDATE', 'withdrawal', 15, 'Saved withdrawal 2026-101175 with 1 line(s)', '::1', '2026-10-21 08:47:30'),
(242, 1, 'SAVE_DRAFT', 'sales_order', 3, 'Saved local Sales Order draft 2775 for withdrawal 2026-101175 with 1 line(s)', '::1', '2026-10-21 08:48:13'),
(243, 1, 'CREATE', 'withdrawal', 16, 'Saved withdrawal 2026-101176 with 1 line(s)', '::1', '2026-10-21 08:49:11'),
(244, 1, 'SAVE_DRAFT', 'invoice', 12, 'Saved invoice draft for 2026-101176 with 1 line(s)', '::1', '2026-10-21 08:49:46'),
(245, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-21 09:08:18'),
(246, 1, 'SAVE_DRAFT', 'invoice', 12, 'Saved invoice draft for 2026-101176 with 1 line(s)', '::1', '2026-10-21 09:46:26'),
(247, 1, 'SAVE_DRAFT', 'sales_order', 3, 'Saved local Sales Order draft 2775 for withdrawal 2026-101175 with 1 line(s)', '::1', '2026-10-21 09:46:44'),
(248, 1, 'SAVE_DRAFT', 'invoice', 12, 'Saved invoice draft for 2026-101176 with 1 line(s)', '::1', '2026-10-21 09:49:45'),
(249, 1, 'LOGIN', 'employee', 1, 'Successful login', '::1', '2026-10-21 12:50:12'),
(250, 1, 'DEACTIVATE', 'site', 7, 'Updated site Toplis Logistics Inc', '::1', '2026-10-21 12:51:38');

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_name` varchar(180) NOT NULL,
  `qb_list_id` varchar(100) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`id`, `client_name`, `qb_list_id`, `active`, `created_at`) VALUES
(1, 'Puregold', NULL, 1, '2026-10-13 08:48:43'),
(2, 'SM', NULL, 0, '2026-10-13 08:48:43'),
(3, 'Alfamart', NULL, 0, '2026-10-13 08:48:43'),
(4, 'Mendoza   Store', NULL, 1, '2026-10-20 09:38:35'),
(5, 'CBFTEE CORPORATION', NULL, 1, '2026-10-20 09:38:35'),
(6, 'Roslin and Ronel Frozen Store', NULL, 1, '2026-10-20 09:38:35'),
(7, 'Three M & MCV Sar-Sari   Store', NULL, 1, '2026-10-20 09:38:35'),
(8, 'J.A.C / Jeffrey store', NULL, 1, '2026-10-20 09:38:35'),
(9, 'Gary Siopao and Siomai Foods   Corner', NULL, 1, '2026-10-20 09:38:35'),
(10, '18 Viking-PA South Food   Ventures Inc.', NULL, 1, '2026-10-20 09:38:35'),
(11, '04 Pa Marikina Food Ventures   Inc-Marikina', NULL, 1, '2026-10-20 09:38:35'),
(12, 'PA Venue Food Ventures, Inc.-   Greenhils', NULL, 1, '2026-10-20 09:38:35'),
(13, '03 PA Pampanga Food Ventures   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(14, 'KFI Trading Corp  (Kerrimo)', NULL, 1, '2026-10-20 09:38:35'),
(15, '243 Frozen Foods Store', NULL, 1, '2026-10-20 09:38:35'),
(16, 'Sienna A. Enriques Store', NULL, 1, '2026-10-20 09:38:35'),
(17, 'nob;e', NULL, 1, '2026-10-20 09:38:35'),
(18, 'Iglesia Ni Cirsto - FCC', NULL, 1, '2026-10-20 09:38:35'),
(19, 'CGEA Minimart', NULL, 1, '2026-10-20 09:38:35'),
(20, 'Marilou Santos Yim Store', NULL, 1, '2026-10-20 09:38:35'),
(21, 'AYOE', NULL, 1, '2026-10-20 09:38:35'),
(22, 'J.N.J Services Based   Specialist and Food', NULL, 1, '2026-10-20 09:38:35'),
(23, 'Makati Shangri-la Hotel and   Resort Inc- 2', NULL, 1, '2026-10-20 09:38:35'),
(24, 'Z Coffee Resto & Bar', NULL, 1, '2026-10-20 09:38:35'),
(25, 'Fame Dish Inc. Brotzeit   Philippines', NULL, 1, '2026-10-20 09:38:35'),
(26, 'VIKINGS', NULL, 0, '2026-10-20 09:38:35'),
(27, 'VIKINGS:03 PA Pampanga Food   Ventures Inc. - laoag', NULL, 1, '2026-10-20 09:38:35'),
(28, 'VIKINGS:03 Pa Pampanga Food   Ventures Inc-Pampanga', NULL, 1, '2026-10-20 09:38:35'),
(29, 'VIKINGS:11 PA Venue Food   Ventures Inc. Jazz', NULL, 1, '2026-10-20 09:38:35'),
(30, 'VIKINGS:04 PA Marikina Food   Venture Inc. Gate Way', NULL, 1, '2026-10-20 09:38:35'),
(31, 'VIKINGS:PA Highland Food   Ventures,Inc.-TAGAYTAY', NULL, 1, '2026-10-20 09:38:35'),
(32, 'VIKINGS:04 PA Marikina Food   Ventures Inc. eastwoo', NULL, 1, '2026-10-20 09:38:35'),
(33, 'VIKINGS:22 PA Nord Food   Ventures Inc.', NULL, 1, '2026-10-20 09:38:35'),
(34, 'VIKINGS:PA Uptown Food   Ventures Inc. - Alley BGC', NULL, 1, '2026-10-20 09:38:35'),
(35, 'VIKINGS:PA Uptown Food   Ventures Inc. - Cloverleaf', NULL, 1, '2026-10-20 09:38:35'),
(36, 'VIKINGS:PA Uptown Food   Ventures Inc. - Fairview', NULL, 1, '2026-10-20 09:38:35'),
(37, 'VIKINGS:PA Uptown Food   Ventures Inc. - Uptown', NULL, 1, '2026-10-20 09:38:35'),
(38, 'VIKINGS:11 PA Venue Food   Ventures Inc. - Venue', NULL, 1, '2026-10-20 09:38:35'),
(39, 'VIKINGS:PA Uptown Food   Ventures Inc. - AMMB', NULL, 1, '2026-10-20 09:38:35'),
(40, 'VIKINGS:18 Vikings PA South   Food Ventures Inc MOA', NULL, 1, '2026-10-20 09:38:35'),
(41, 'VIKINGS:The Niufund Corp.', NULL, 1, '2026-10-20 09:38:35'),
(42, 'Happyfoods Corporation', NULL, 1, '2026-10-20 09:38:35'),
(43, 'Ritchel Fabella', NULL, 1, '2026-10-20 09:38:35'),
(44, 'Kabayan Store', NULL, 1, '2026-10-20 09:38:35'),
(45, 'Narding Store', NULL, 1, '2026-10-20 09:38:35'),
(46, 'Zahraj\'s Frozen Foods   store/Lenny Store', NULL, 1, '2026-10-20 09:38:35'),
(47, 'L.Lauta Cold Cuts Storage', NULL, 1, '2026-10-20 09:38:35'),
(48, 'WILDE', NULL, 1, '2026-10-20 09:38:35'),
(49, 'Alvic Store', NULL, 1, '2026-10-20 09:38:35'),
(50, 'MBCM Valerio Meat Shop', NULL, 1, '2026-10-20 09:38:35'),
(51, 'Wildflour BGC', NULL, 1, '2026-10-20 09:38:35'),
(52, 'DOROTHY FROZEN FOOD\'S STORE', NULL, 1, '2026-10-20 09:38:35'),
(53, 'Patricia Marie Galang', NULL, 1, '2026-10-20 09:38:35'),
(54, 'LIZA & RIKKI STORE', NULL, 1, '2026-10-20 09:38:35'),
(55, 'JANETH VILLANUEVA METRTILLO', NULL, 1, '2026-10-20 09:38:35'),
(56, 'MARY ANN COLD CUTS STORE', NULL, 1, '2026-10-20 09:38:35'),
(57, 'YG Food Store', NULL, 1, '2026-10-20 09:38:35'),
(58, 'Sharon Bitao food Store/Alon   store', NULL, 1, '2026-10-20 09:38:35'),
(59, 'Rhea Frozen Meal', NULL, 1, '2026-10-20 09:38:35'),
(60, 'HILDA SARI-SARI STORE', NULL, 1, '2026-10-20 09:38:35'),
(61, 'TITA MARIE STORE', NULL, 1, '2026-10-20 09:38:35'),
(62, 'Chef Mikey', NULL, 1, '2026-10-20 09:38:35'),
(63, 'PPI Holdings, Inc.', NULL, 1, '2026-10-20 09:38:35'),
(64, 'Kuya Owen', NULL, 1, '2026-10-20 09:38:35'),
(65, 'JC Mejia Store', NULL, 1, '2026-10-20 09:38:35'),
(66, 'Relson Miranda Cold Cuts', NULL, 1, '2026-10-20 09:38:35'),
(67, 'Carl Bryan Ollie H. Lasco', NULL, 1, '2026-10-20 09:38:35'),
(68, 'SRI Food Delight, Inc.', NULL, 1, '2026-10-20 09:38:35'),
(69, 'Thea Marie Store', NULL, 1, '2026-10-20 09:38:35'),
(70, 'Tess Store', NULL, 1, '2026-10-20 09:38:35'),
(71, 'Sto. Niño Food Store', NULL, 1, '2026-10-20 09:38:35'),
(72, 'Hamor Food Product', NULL, 1, '2026-10-20 09:38:35'),
(73, 'Isabel Pascual Frozen Products', NULL, 1, '2026-10-20 09:38:35'),
(74, 'Friend Food Store', NULL, 1, '2026-10-20 09:38:35'),
(75, 'Vera cafe', NULL, 1, '2026-10-20 09:38:35'),
(76, 'Account Mainstores Commercial   Corporation', NULL, 1, '2026-10-20 09:38:35'),
(77, 'Wegan Store', NULL, 1, '2026-10-20 09:38:35'),
(78, 'INC', NULL, 1, '2026-10-20 09:38:35'),
(79, 'INC:NEW ERA CANTEEN 2', NULL, 1, '2026-10-20 09:38:35'),
(80, 'INC:Embrace Cafe (Unlad)', NULL, 1, '2026-10-20 09:38:35'),
(81, 'INC:Iglesia Ni Cristo(School   of Ministry)', NULL, 1, '2026-10-20 09:38:35'),
(82, 'INC:Iglesia ni Cristo (PSB   Canteens)', NULL, 1, '2026-10-20 09:38:35'),
(83, 'INC:Iglesia Ni Cristo (New Era   Canteen)', NULL, 1, '2026-10-20 09:38:35'),
(84, 'INC:Iglesia Ni Cristo (Central   Kitchen)', NULL, 1, '2026-10-20 09:38:35'),
(85, 'Alfamart Trading Philippines   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(86, 'Larry\'s Food Store', NULL, 1, '2026-10-20 09:38:35'),
(87, 'Burger Kong', NULL, 1, '2026-10-20 09:38:35'),
(88, 'Bistro Group Inc. 1605', NULL, 1, '2026-10-20 09:38:35'),
(89, 'Ronald Melendez', NULL, 1, '2026-10-20 09:38:35'),
(90, 'Driane\'s Foodstore', NULL, 1, '2026-10-20 09:38:35'),
(91, 'Rayatech Corporation', NULL, 1, '2026-10-20 09:38:35'),
(92, 'Epicsouthbank Inc.', NULL, 1, '2026-10-20 09:38:35'),
(93, 'Jems Meat Shop', NULL, 1, '2026-10-20 09:38:35'),
(94, 'Filinvest Hospitality   Corporation', NULL, 1, '2026-10-20 09:38:35'),
(95, 'Jehova Jireh Processed Food   Products Whol', NULL, 1, '2026-10-20 09:38:35'),
(96, 'Arm Forces of The Philippines   Commissary', NULL, 1, '2026-10-20 09:38:35'),
(97, 'Happy Fries', NULL, 1, '2026-10-20 09:38:35'),
(98, 'France Cuevas', NULL, 1, '2026-10-20 09:38:35'),
(99, 'RODEL VERANO', NULL, 1, '2026-10-20 09:38:35'),
(100, 'Mack-Mack Store', NULL, 1, '2026-10-20 09:38:35'),
(101, 'Big Bites', NULL, 1, '2026-10-20 09:38:35'),
(102, 'Sir Gigs', NULL, 1, '2026-10-20 09:38:35'),
(103, 'Julie San Pablo', NULL, 1, '2026-10-20 09:38:35'),
(104, 'Jonathan Morgado', NULL, 1, '2026-10-20 09:38:35'),
(105, 'Grupo Ramos Enterprise and   Trading Corpor', NULL, 1, '2026-10-20 09:38:35'),
(106, 'Cafe Rinnah', NULL, 1, '2026-10-20 09:38:35'),
(107, 'CASH\'', NULL, 1, '2026-10-20 09:38:35'),
(108, 'AIE', NULL, 1, '2026-10-20 09:38:35'),
(109, 'Nomielyn Ruiz store', NULL, 1, '2026-10-20 09:38:35'),
(110, 'Abe and Jessica Frozen Goods', NULL, 1, '2026-10-20 09:38:35'),
(111, 'Budget KIng', NULL, 1, '2026-10-20 09:38:35'),
(112, 'Budget KIng:ML Budget King   Supermarket Corporation', NULL, 1, '2026-10-20 09:38:35'),
(113, 'Budget KIng:Sixth Budget King   Supermarket Philppines,', NULL, 1, '2026-10-20 09:38:35'),
(114, 'Budget KIng:Prime Budget King   Supermarket Corporation', NULL, 1, '2026-10-20 09:38:35'),
(115, 'Budget KIng:Bayside   Supermarket Corporation', NULL, 1, '2026-10-20 09:38:35'),
(116, 'Budget KIng:Fifth Budget King   Supermarket Philippines', NULL, 1, '2026-10-20 09:38:35'),
(117, 'BGISIS Development Corporation', NULL, 1, '2026-10-20 09:38:35'),
(118, 'DE Novo', NULL, 1, '2026-10-20 09:38:35'),
(119, 'Macroasia Catering Services   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(120, 'Tita Meryll Food Shop 2', NULL, 1, '2026-10-20 09:38:35'),
(121, 'OH Meal Meaty Products', NULL, 1, '2026-10-20 09:38:35'),
(122, 'Neneng V Food Store', NULL, 1, '2026-10-20 09:38:35'),
(123, 'Marvin Store', NULL, 1, '2026-10-20 09:38:35'),
(124, 'Beanstalk', NULL, 1, '2026-10-20 09:38:35'),
(125, 'Windy Peak Cafe', NULL, 1, '2026-10-20 09:38:35'),
(126, 'Jia\'s Korean Hot Pot', NULL, 1, '2026-10-20 09:38:35'),
(127, 'E.M.J.I Frozen Store', NULL, 1, '2026-10-20 09:38:35'),
(128, '6 ten Food Stall', NULL, 1, '2026-10-20 09:38:35'),
(129, 'ECCN Frozen Food Trading', NULL, 1, '2026-10-20 09:38:35'),
(130, 'San Isidro Food Trading', NULL, 1, '2026-10-20 09:38:35'),
(131, 'Sir Israel', NULL, 1, '2026-10-20 09:38:35'),
(132, 'Grocee', NULL, 1, '2026-10-20 09:38:35'),
(133, 'J.P Gallardo', NULL, 1, '2026-10-20 09:38:35'),
(134, 'AT\\\\', NULL, 1, '2026-10-20 09:38:35'),
(135, 'Mam Arlene', NULL, 1, '2026-10-20 09:38:35'),
(136, 'Holand Hopia & Asian Deli   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(137, 'Little Starieee Food Kiosk', NULL, 1, '2026-10-20 09:38:35'),
(138, '222 Kaffe', NULL, 1, '2026-10-20 09:38:35'),
(139, '2447 Store Remy Chan', NULL, 1, '2026-10-20 09:38:35'),
(140, '3 Sisters', NULL, 1, '2026-10-20 09:38:35'),
(141, '3Jem Food Products Marketing', NULL, 1, '2026-10-20 09:38:35'),
(142, '7evendays coffee', NULL, 1, '2026-10-20 09:38:35'),
(143, '7TWENTY7 AMERICAN DINER', NULL, 1, '2026-10-20 09:38:35'),
(144, '8 fish', NULL, 1, '2026-10-20 09:38:35'),
(145, '80/20 Burger', NULL, 1, '2026-10-20 09:38:35'),
(146, 'A.HILARIO TRUCKING SERVICES', NULL, 1, '2026-10-20 09:38:35'),
(147, 'ABDULRASHID PANDACA', NULL, 1, '2026-10-20 09:38:35'),
(148, 'Abigail Food Cart', NULL, 1, '2026-10-20 09:38:35'),
(149, 'ACDP Consumer Goods Trading', NULL, 1, '2026-10-20 09:38:35'),
(150, 'Ada Pamatpat', NULL, 1, '2026-10-20 09:38:35'),
(151, 'ADDIE\'S STEAKHOUSE', NULL, 1, '2026-10-20 09:38:35'),
(152, 'Aerol Food Store', NULL, 1, '2026-10-20 09:38:35'),
(153, 'AG Finance INC.', NULL, 1, '2026-10-20 09:38:35'),
(154, 'Aga Simbulan', NULL, 1, '2026-10-20 09:38:35'),
(155, 'Ahl Sacar', NULL, 1, '2026-10-20 09:38:35'),
(156, 'AILEEN OLABRE', NULL, 1, '2026-10-20 09:38:35'),
(157, 'Airol Store', NULL, 1, '2026-10-20 09:38:35'),
(158, 'AIZA OLABRE', NULL, 1, '2026-10-20 09:38:35'),
(159, 'Al-jen Frozen Food Trading', NULL, 1, '2026-10-20 09:38:35'),
(160, 'Albrighton Corporation', NULL, 1, '2026-10-20 09:38:35'),
(161, 'Aldrin Ragas', NULL, 1, '2026-10-20 09:38:35'),
(162, 'Alexandra Puno', NULL, 1, '2026-10-20 09:38:35'),
(163, 'Ali Makati Hotel Property Inc.', NULL, 1, '2026-10-20 09:38:35'),
(164, 'Aling Glenda Monster Porkchop', NULL, 1, '2026-10-20 09:38:35'),
(165, 'All Link Hotel and Resorts   Group Lmt. Inc', NULL, 1, '2026-10-20 09:38:35'),
(166, 'AllAboutFried Food Concession   Services', NULL, 1, '2026-10-20 09:38:35'),
(167, 'Allegria Milktea Shop', NULL, 1, '2026-10-20 09:38:35'),
(168, 'Almacen', NULL, 1, '2026-10-20 09:38:35'),
(169, 'Alphaland Balesin Island   Club,Inc.', NULL, 1, '2026-10-20 09:38:35'),
(170, 'Alvarez Frozen Food Depot', NULL, 1, '2026-10-20 09:38:35'),
(171, 'Alvarez Store', NULL, 1, '2026-10-20 09:38:35'),
(172, 'Alvin Rubio', NULL, 1, '2026-10-20 09:38:35'),
(173, 'AM-PHIL FOODS CONCEPTS,INC.', NULL, 1, '2026-10-20 09:38:35'),
(174, 'Amaco Inc.', NULL, 1, '2026-10-20 09:38:35'),
(175, 'AMBR Food and Beverages OPC', NULL, 1, '2026-10-20 09:38:35'),
(176, 'American Bean Restaurant Inc.', NULL, 1, '2026-10-20 09:38:35'),
(177, 'AMERICAN WINGHOUSE SUMULONG', NULL, 1, '2026-10-20 09:38:35'),
(178, 'Amihan Trading Corporation', NULL, 1, '2026-10-20 09:38:35'),
(179, 'Amphie Store', NULL, 1, '2026-10-20 09:38:35'),
(180, 'Amy Daidy Store Corp', NULL, 1, '2026-10-20 09:38:35'),
(181, 'Amy Urgino', NULL, 1, '2026-10-20 09:38:35'),
(182, 'Andok\'s Litson Corp.', NULL, 1, '2026-10-20 09:38:35'),
(183, 'Angel & John Store', NULL, 1, '2026-10-20 09:38:35'),
(184, 'Angela Lauchengco', NULL, 1, '2026-10-20 09:38:35'),
(185, 'ANGIELA SULLA', NULL, 1, '2026-10-20 09:38:35'),
(186, 'Ann Baculto', NULL, 1, '2026-10-20 09:38:35'),
(187, 'Anna Store', NULL, 1, '2026-10-20 09:38:35'),
(188, 'Anne Omadto', NULL, 1, '2026-10-20 09:38:35'),
(189, 'April De Luna', NULL, 1, '2026-10-20 09:38:35'),
(190, 'AR J\'s Frozen Foods', NULL, 1, '2026-10-20 09:38:35'),
(191, 'Arcielo Food Trading', NULL, 1, '2026-10-20 09:38:35'),
(192, 'Aries Luntok', NULL, 1, '2026-10-20 09:38:35'),
(193, 'ARJ\'S FROZEN FOODS', NULL, 1, '2026-10-20 09:38:35'),
(194, 'Arzen Trucking', NULL, 1, '2026-10-20 09:38:35'),
(195, 'Asian Gourmet Food Corporation', NULL, 1, '2026-10-20 09:38:35'),
(196, 'AT Catering Services opc', NULL, 1, '2026-10-20 09:38:35'),
(197, 'AT8 Marketing', NULL, 1, '2026-10-20 09:38:35'),
(198, 'Ate Baby\'s Carinderia', NULL, 1, '2026-10-20 09:38:35'),
(199, 'Aurick Go', NULL, 1, '2026-10-20 09:38:35'),
(200, 'Auro Chocolate Cafe Inc.', NULL, 1, '2026-10-20 09:38:35'),
(201, 'Ayagold Retailers,Inc.', NULL, 1, '2026-10-20 09:38:35'),
(202, 'AYIE STORE', NULL, 1, '2026-10-20 09:38:35'),
(203, 'B. Alvarez', NULL, 1, '2026-10-20 09:38:35'),
(204, 'Baby Zarte', NULL, 1, '2026-10-20 09:38:35'),
(205, 'Balai Yllana Food Services', NULL, 1, '2026-10-20 09:38:35'),
(206, 'Bamboo Intramuros Corp.', NULL, 1, '2026-10-20 09:38:35'),
(207, 'Bar Bits Store', NULL, 1, '2026-10-20 09:38:35'),
(208, 'BBO Frosty Frozen Food   Enterprises', NULL, 1, '2026-10-20 09:38:35'),
(209, 'Bea Binene', NULL, 1, '2026-10-20 09:38:35'),
(210, 'Bea Pecho', NULL, 1, '2026-10-20 09:38:35'),
(211, 'Bean N\' Cup', NULL, 1, '2026-10-20 09:38:35'),
(212, 'Belcris', NULL, 1, '2026-10-20 09:38:35'),
(213, 'Ben\'s Halo Halo Ice Cream', NULL, 1, '2026-10-20 09:38:35'),
(214, 'Ben\'s Halo Halo Ice   Cream:Paseo de Sta.Rosa', NULL, 1, '2026-10-20 09:38:35'),
(215, 'Ben\'s Halo Halo Ice Cream:SLEX', NULL, 1, '2026-10-20 09:38:35'),
(216, 'Ben\'s Halo Halo Ice   Cream:Viewfort', NULL, 1, '2026-10-20 09:38:35'),
(217, 'Berlin Tumnob', NULL, 1, '2026-10-20 09:38:35'),
(218, 'BEST VALUE FACTORY OUTLET   CORP.', NULL, 1, '2026-10-20 09:38:35'),
(219, 'Beverly Jean Halaman', NULL, 1, '2026-10-20 09:38:35'),
(220, 'BICENTENNIAL FOOD CONGLOMERATE   CORP', NULL, 1, '2026-10-20 09:38:35'),
(221, 'Bicho Bites Inc.', NULL, 1, '2026-10-20 09:38:35'),
(222, 'BIGG\'S INC.', NULL, 1, '2026-10-20 09:38:35'),
(223, 'BITES & TEAS FOOD STALL', NULL, 1, '2026-10-20 09:38:35'),
(224, 'Blissful V\'s Consumer Goods   Trading', NULL, 1, '2026-10-20 09:38:35'),
(225, 'BMTC Distributors Inc', NULL, 1, '2026-10-20 09:38:35'),
(226, 'Bonie Tan', NULL, 1, '2026-10-20 09:38:35'),
(227, 'Boracay Seascapes Inc.', NULL, 1, '2026-10-20 09:38:35'),
(228, 'BORRO MANILA', NULL, 1, '2026-10-20 09:38:35'),
(229, 'BR Corporate Services Inc.', NULL, 1, '2026-10-20 09:38:35'),
(230, 'BR Marketing', NULL, 1, '2026-10-20 09:38:35'),
(231, 'Brewers Haven Inc.', NULL, 1, '2026-10-20 09:38:35'),
(232, 'Brix HT', NULL, 1, '2026-10-20 09:38:35'),
(233, 'BUKID INC.', NULL, 1, '2026-10-20 09:38:35'),
(234, 'Cafe Angela', NULL, 1, '2026-10-20 09:38:35'),
(235, 'California Steaks', NULL, 1, '2026-10-20 09:38:35'),
(236, 'Calle Rizal Cafe', NULL, 1, '2026-10-20 09:38:35'),
(237, 'Camabela Meatshop', NULL, 1, '2026-10-20 09:38:35'),
(238, 'CAMILLE LEE', NULL, 1, '2026-10-20 09:38:35'),
(239, 'Canbro Concepts Holdings Inc.', NULL, 1, '2026-10-20 09:38:35'),
(240, 'Candy and Cherry Mktg. Corp', NULL, 1, '2026-10-20 09:38:35'),
(241, 'Carmela Sison', NULL, 1, '2026-10-20 09:38:35'),
(242, 'CAROL TIU', NULL, 1, '2026-10-20 09:38:35'),
(243, 'CARRIEDO TOURIST DEVELOPMENT   INC.', NULL, 1, '2026-10-20 09:38:35'),
(244, 'Casa Jardin De Mellizo', NULL, 1, '2026-10-20 09:38:35'),
(245, 'Catgie Frozen Goods', NULL, 1, '2026-10-20 09:38:35'),
(246, 'CATHERINE ANN SOLEDAD', NULL, 1, '2026-10-20 09:38:35'),
(247, 'CBY Foods', NULL, 1, '2026-10-20 09:38:35'),
(248, 'CELO FOOD CORPORATION', NULL, 1, '2026-10-20 09:38:35'),
(249, 'Cess Santos', NULL, 1, '2026-10-20 09:38:35'),
(250, 'CFTRI Distribution Corp.', NULL, 1, '2026-10-20 09:38:35'),
(251, 'CGM Food Corp.', NULL, 1, '2026-10-20 09:38:35'),
(252, 'CHARISSE BAUTISTA', NULL, 1, '2026-10-20 09:38:35'),
(253, 'Charlene Alabanza', NULL, 1, '2026-10-20 09:38:35'),
(254, 'Charlotte\'s Minimart', NULL, 1, '2026-10-20 09:38:35'),
(255, 'Cherry Lim Tan', NULL, 1, '2026-10-20 09:38:35'),
(256, 'Chick N\' Fries', NULL, 1, '2026-10-20 09:38:35'),
(257, 'Chim Miranda', NULL, 1, '2026-10-20 09:38:35'),
(258, 'Christine Salonga', NULL, 1, '2026-10-20 09:38:35'),
(259, 'Christy Balatucan', NULL, 1, '2026-10-20 09:38:35'),
(260, 'Ciso\'s Grill Meat Stop and   Restaurant', NULL, 1, '2026-10-20 09:38:35'),
(261, 'CKM Gourmet Food Hub', NULL, 1, '2026-10-20 09:38:35'),
(262, 'Clarissa Kit', NULL, 1, '2026-10-20 09:38:35'),
(263, 'Clarissa Vitug', NULL, 1, '2026-10-20 09:38:35'),
(264, 'Clark Freeport Trading   Resources Inc.', NULL, 1, '2026-10-20 09:38:35'),
(265, 'Cloddeth Allyza', NULL, 1, '2026-10-20 09:38:35'),
(266, 'CMM Supreme', NULL, 1, '2026-10-20 09:38:35'),
(267, 'Coco Fuel Inc.', NULL, 1, '2026-10-20 09:38:35'),
(268, 'Cold Brew Corporation', NULL, 1, '2026-10-20 09:38:35'),
(269, 'Cookie\'s Coffee Shop and   Restaurant', NULL, 1, '2026-10-20 09:38:35'),
(270, 'Coral Kitchen', NULL, 1, '2026-10-20 09:38:35'),
(271, 'Cow Wow Sausage Haus', NULL, 1, '2026-10-20 09:38:35'),
(272, 'Cravefast Inc.', NULL, 1, '2026-10-20 09:38:35'),
(273, 'Cravers Corner', NULL, 1, '2026-10-20 09:38:35'),
(274, 'D\' Hidden Brew Coffee Shop', NULL, 1, '2026-10-20 09:38:35'),
(275, 'Dailymoods Consumer Goods   Trading', NULL, 1, '2026-10-20 09:38:35'),
(276, 'Dailyrev Cafe', NULL, 1, '2026-10-20 09:38:35'),
(277, 'daisy salipot', NULL, 1, '2026-10-20 09:38:35'),
(278, 'Daniel Geronimo', NULL, 1, '2026-10-20 09:38:35'),
(279, 'DANIEL SOBREPEÑA', NULL, 1, '2026-10-20 09:38:35'),
(280, 'David\'s Delicious Food   Processing Corp.', NULL, 1, '2026-10-20 09:38:35'),
(281, 'DEAN AND DELUCA PHILIPPINES   INC.', NULL, 1, '2026-10-20 09:38:35'),
(282, 'Dean list KTV bar', NULL, 1, '2026-10-20 09:38:35'),
(283, 'Decebelle Montefrio', NULL, 1, '2026-10-20 09:38:35'),
(284, 'Dee Hwa Liong Academy', NULL, 1, '2026-10-20 09:38:35'),
(285, 'Del Monton Frozen Foods', NULL, 1, '2026-10-20 09:38:35'),
(286, 'Delectable Feast Corporation', NULL, 1, '2026-10-20 09:38:35'),
(287, 'Delfin Tolentino', NULL, 1, '2026-10-20 09:38:35'),
(288, 'Dianne\'s Cold Storage', NULL, 1, '2026-10-20 09:38:35'),
(289, 'DINER 55', NULL, 1, '2026-10-20 09:38:35'),
(290, 'DKD Noventa Burger Kiosk', NULL, 1, '2026-10-20 09:38:35'),
(291, 'DONNA ORTEGA', NULL, 1, '2026-10-20 09:38:35'),
(292, 'Dory\'s Frozen Goods', NULL, 1, '2026-10-20 09:38:35'),
(293, 'Dykee\'s', NULL, 1, '2026-10-20 09:38:35'),
(294, 'E & C FOOD HUB', NULL, 1, '2026-10-20 09:38:35'),
(295, 'Eastern Blend Food Corp', NULL, 1, '2026-10-20 09:38:35'),
(296, 'Eastworld Sales Philippines   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(297, 'Eden Uang', NULL, 1, '2026-10-20 09:38:35'),
(298, 'Edison Ching Padilla', NULL, 1, '2026-10-20 09:38:35'),
(299, 'Edlyn Frozen Products', NULL, 1, '2026-10-20 09:38:35'),
(300, 'Edsa Shangri-La Hotel and   Resort Inc.', NULL, 1, '2026-10-20 09:38:35'),
(301, 'Eduardo Nunag Consumer Goods', NULL, 1, '2026-10-20 09:38:35'),
(302, 'Edward Dela Cruz', NULL, 1, '2026-10-20 09:38:35'),
(303, 'EL BUENO FOOD INC.', NULL, 1, '2026-10-20 09:38:35'),
(304, 'Elaine Alano', NULL, 1, '2026-10-20 09:38:35'),
(305, 'Elena Choa', NULL, 1, '2026-10-20 09:38:35'),
(306, 'Ellaine Franco', NULL, 1, '2026-10-20 09:38:35'),
(307, 'Elsie Ong', NULL, 1, '2026-10-20 09:38:35'),
(308, 'EM Sari-Sari Store', NULL, 1, '2026-10-20 09:38:35'),
(309, 'Emily Frozen Food Trading', NULL, 1, '2026-10-20 09:38:35'),
(310, 'Emman\'s store', NULL, 1, '2026-10-20 09:38:35'),
(311, 'EN ROUTE', NULL, 1, '2026-10-20 09:38:35'),
(312, 'Ericka Psalm E', NULL, 1, '2026-10-20 09:38:35'),
(313, 'Estaidha Frozen', NULL, 1, '2026-10-20 09:38:35'),
(314, 'Ester Store', NULL, 1, '2026-10-20 09:38:35'),
(315, 'Ethan and Evans Food Depot', NULL, 1, '2026-10-20 09:38:35'),
(316, 'Eva Gonzales', NULL, 1, '2026-10-20 09:38:35'),
(317, 'Everything Gourmet Enterprises   Inc', NULL, 1, '2026-10-20 09:38:35'),
(318, 'FARM TO MAYANI INC.', NULL, 1, '2026-10-20 09:38:35'),
(319, 'Farmers Table Restaurant (MCH)', NULL, 1, '2026-10-20 09:38:35'),
(320, 'Fattie Guys Food House', NULL, 1, '2026-10-20 09:38:35'),
(321, 'Filomena Padilla', NULL, 1, '2026-10-20 09:38:35'),
(322, 'First Ground Resto Bar', NULL, 1, '2026-10-20 09:38:35'),
(323, 'Flavorlicious inc.', NULL, 1, '2026-10-20 09:38:35'),
(324, 'Florence Lazaro', NULL, 1, '2026-10-20 09:38:35'),
(325, 'FOOD DETAILS INC.', NULL, 1, '2026-10-20 09:38:35'),
(326, 'Food Patrol Trading', NULL, 1, '2026-10-20 09:38:35'),
(327, 'Food Politics', NULL, 1, '2026-10-20 09:38:35'),
(328, 'Foodgasm', NULL, 1, '2026-10-20 09:38:35'),
(329, 'FoodParks By Raintree', NULL, 1, '2026-10-20 09:38:35'),
(330, 'Fourman Ventures Corporation', NULL, 1, '2026-10-20 09:38:35'),
(331, 'FRABELLE MARKET CORPORATIION', NULL, 1, '2026-10-20 09:38:35'),
(332, 'Francis Meatshop', NULL, 1, '2026-10-20 09:38:35'),
(333, 'French Baker Inc.', NULL, 1, '2026-10-20 09:38:35'),
(334, 'FRENZ MANALILI', NULL, 1, '2026-10-20 09:38:35'),
(335, 'Fuesto', NULL, 1, '2026-10-20 09:38:35'),
(336, 'Gab Frozen', NULL, 1, '2026-10-20 09:38:35'),
(337, 'Gamboa Group Inc.', NULL, 1, '2026-10-20 09:38:35'),
(338, 'Gammad Payment Center', NULL, 1, '2026-10-20 09:38:35'),
(339, 'GI LAO', NULL, 1, '2026-10-20 09:38:35'),
(340, 'Gil Esptipona', NULL, 1, '2026-10-20 09:38:35'),
(341, 'Gilbert Manila', NULL, 1, '2026-10-20 09:38:35'),
(342, 'GLADYS STORE', NULL, 1, '2026-10-20 09:38:35'),
(343, 'Global 168 Marketing Corp.', NULL, 1, '2026-10-20 09:38:35'),
(344, 'Golden Brew Cavite Coffee Shop', NULL, 1, '2026-10-20 09:38:35'),
(345, 'Golden Buddha', NULL, 1, '2026-10-20 09:38:35'),
(346, 'Golden Camarines Multi Foods   Corp', NULL, 1, '2026-10-20 09:38:35'),
(347, 'Golden Camarines Multi Foods   Corp:Golden Camarines Multi Foods', NULL, 1, '2026-10-20 09:38:35'),
(348, 'Golden Camarines Multi Foods   Corp:GC-Naga', NULL, 1, '2026-10-20 09:38:35'),
(349, 'Goodfare Trading', NULL, 1, '2026-10-20 09:38:35'),
(350, 'Grace Gabrinao', NULL, 1, '2026-10-20 09:38:35'),
(351, 'GRACE LASANAS', NULL, 1, '2026-10-20 09:38:35'),
(352, 'Gracelyn Sari Sari Store', NULL, 1, '2026-10-20 09:38:35'),
(353, 'Green Asia Resources Corp.', NULL, 1, '2026-10-20 09:38:35'),
(354, 'Happiest Tummy Restaurant   Corp.', NULL, 1, '2026-10-20 09:38:35'),
(355, 'HAPPY TEAS ASIA INC.', NULL, 1, '2026-10-20 09:38:35'),
(356, 'Hazel Candelario', NULL, 1, '2026-10-20 09:38:35'),
(357, 'Heidi Vidal', NULL, 1, '2026-10-20 09:38:35'),
(358, 'Hi-Top Supermart Inc.', NULL, 1, '2026-10-20 09:38:35'),
(359, 'Hi-Top Supermart   Inc.:HI-Quezon Ave', NULL, 1, '2026-10-20 09:38:35'),
(360, 'Hi-Top Supermart   Inc.:HT-aurora', NULL, 1, '2026-10-20 09:38:35'),
(361, 'Hightower, Inc.', NULL, 1, '2026-10-20 09:38:35'),
(362, 'HILAGANG EDSA TOURIST INC.', NULL, 1, '2026-10-20 09:38:35'),
(363, 'Hofu Japanese Restaurant', NULL, 1, '2026-10-20 09:38:35'),
(364, 'Home Baking Depot', NULL, 1, '2026-10-20 09:38:35'),
(365, 'Home Grocer Grocery Products   Trading', NULL, 1, '2026-10-20 09:38:35'),
(366, 'Hot Potato', NULL, 1, '2026-10-20 09:38:35'),
(367, 'HRT VENTURES CORPORATION', NULL, 1, '2026-10-20 09:38:35'),
(368, 'Hungry Treats Food Corp.', NULL, 1, '2026-10-20 09:38:35'),
(369, 'ILOILO Prime Foods Ventures', NULL, 1, '2026-10-20 09:38:35'),
(370, 'ILT Food Products', NULL, 1, '2026-10-20 09:38:35'),
(371, 'Inn Reource Philippines OPC', NULL, 1, '2026-10-20 09:38:35'),
(372, 'IPlay Marketing Inc.', NULL, 1, '2026-10-20 09:38:35'),
(373, 'J3A Food Line Inc.', NULL, 1, '2026-10-20 09:38:35'),
(374, 'JAC Meatshop', NULL, 1, '2026-10-20 09:38:35'),
(375, 'Jacob\'s Bar & Grill', NULL, 1, '2026-10-20 09:38:35'),
(376, 'Jacob\'s Basic First Ventures', NULL, 1, '2026-10-20 09:38:35'),
(377, 'Jacqueline Baura', NULL, 1, '2026-10-20 09:38:35'),
(378, 'Jaja Durano', NULL, 1, '2026-10-20 09:38:35'),
(379, 'James Sapida', NULL, 1, '2026-10-20 09:38:35'),
(380, 'JAMIE DEVESA', NULL, 1, '2026-10-20 09:38:35'),
(381, 'Janeth Store', NULL, 1, '2026-10-20 09:38:35'),
(382, 'Janewa Mae Sedantes', NULL, 1, '2026-10-20 09:38:35'),
(383, 'Jay Ruiz Store', NULL, 1, '2026-10-20 09:38:35'),
(384, 'Jazeel Food Services', NULL, 1, '2026-10-20 09:38:35'),
(385, 'Jazon Abad', NULL, 1, '2026-10-20 09:38:35'),
(386, 'JC Store', NULL, 1, '2026-10-20 09:38:35'),
(387, 'JD Frozen Foods', NULL, 1, '2026-10-20 09:38:35'),
(388, 'Jeffrey Delos Santos', NULL, 1, '2026-10-20 09:38:35'),
(389, 'Jenina Sicosana', NULL, 1, '2026-10-20 09:38:35'),
(390, 'Jenma Food Corp.', NULL, 1, '2026-10-20 09:38:35'),
(391, 'Jeruel Grancapal', NULL, 1, '2026-10-20 09:38:35'),
(392, 'Jessica Meathshop & Frozen   Foods', NULL, 1, '2026-10-20 09:38:35'),
(393, 'Jester Limbing', NULL, 1, '2026-10-20 09:38:35'),
(394, 'Jewel Ann Valeriano', NULL, 1, '2026-10-20 09:38:35'),
(395, 'Jhoan Bautista', NULL, 1, '2026-10-20 09:38:35'),
(396, 'JHOBELLE ARANTE', NULL, 1, '2026-10-20 09:38:35'),
(397, 'JHQ Frozen', NULL, 1, '2026-10-20 09:38:35'),
(398, 'JJF Frozen Goods', NULL, 1, '2026-10-20 09:38:35'),
(399, 'JJP Meat Trading', NULL, 1, '2026-10-20 09:38:35'),
(400, 'JMax', NULL, 1, '2026-10-20 09:38:35'),
(401, 'JMS Food Corp.', NULL, 1, '2026-10-20 09:38:35'),
(402, 'JNB - Cabuyao South Ville', NULL, 1, '2026-10-20 09:38:35'),
(403, 'JNB - Morales Calamba', NULL, 1, '2026-10-20 09:38:35'),
(404, 'JNB - Paciano Rizal', NULL, 1, '2026-10-20 09:38:35'),
(405, 'JNB Food Products', NULL, 1, '2026-10-20 09:38:35'),
(406, 'JNBYSON Frozen Food Trading', NULL, 1, '2026-10-20 09:38:35'),
(407, 'Jnj Frozen Goods', NULL, 1, '2026-10-20 09:38:35'),
(408, 'JNS Food Catering Services', NULL, 1, '2026-10-20 09:38:35'),
(409, 'Jo Garde', NULL, 1, '2026-10-20 09:38:35'),
(410, 'Joaquin Salazar', NULL, 1, '2026-10-20 09:38:35'),
(411, 'Jocelyn Yap', NULL, 1, '2026-10-20 09:38:35'),
(412, 'Joey (NGBL)', NULL, 1, '2026-10-20 09:38:35'),
(413, 'Jon Ace Sulit Toplis', NULL, 1, '2026-10-20 09:38:35'),
(414, 'Jons trading', NULL, 1, '2026-10-20 09:38:35'),
(415, 'JORDAN SUMAMPONG', NULL, 1, '2026-10-20 09:38:35'),
(416, 'Jose Mari 101\'s', NULL, 1, '2026-10-20 09:38:35'),
(417, 'JOSEPH ALMONTE', NULL, 1, '2026-10-20 09:38:35'),
(418, 'Joy Chung', NULL, 1, '2026-10-20 09:38:35'),
(419, 'Joy Villaviray', NULL, 1, '2026-10-20 09:38:35'),
(420, 'JPCC Food Hub', NULL, 1, '2026-10-20 09:38:35'),
(421, 'JRJ wet and dry goods', NULL, 1, '2026-10-20 09:38:35'),
(422, 'JRL Endaya inc.', NULL, 1, '2026-10-20 09:38:35'),
(423, 'JU Enterprise', NULL, 1, '2026-10-20 09:38:35'),
(424, 'JULIE ANN MONTESA', NULL, 1, '2026-10-20 09:38:35'),
(425, 'JW STORE', NULL, 1, '2026-10-20 09:38:35'),
(426, 'KABSAT LA UNION', NULL, 1, '2026-10-20 09:38:35'),
(427, 'Kaizentea', NULL, 1, '2026-10-20 09:38:35'),
(428, 'Kamille Brouwers', NULL, 1, '2026-10-20 09:38:35'),
(429, 'Kape-Ilokano ( Coffee Shop )   OPC', NULL, 1, '2026-10-20 09:38:35'),
(430, 'Kareila Management Corporation', NULL, 1, '2026-10-20 09:38:35'),
(431, 'Katherine Parreno', NULL, 1, '2026-10-20 09:38:35'),
(432, 'Kathy Magsino', NULL, 1, '2026-10-20 09:38:35'),
(433, 'Katrina Bernardo', NULL, 1, '2026-10-20 09:38:35'),
(434, 'Katy Lam', NULL, 1, '2026-10-20 09:38:35'),
(435, 'KAYE BUNAGAN', NULL, 1, '2026-10-20 09:38:35'),
(436, 'Kaye Zosimo', NULL, 1, '2026-10-20 09:38:35'),
(437, 'KC Store', NULL, 1, '2026-10-20 09:38:35'),
(438, 'KD Munchies Snack Corner', NULL, 1, '2026-10-20 09:38:35'),
(439, 'Kemp Group', NULL, 1, '2026-10-20 09:38:35'),
(440, 'Kemp Group:Chan Rey Kenneth Go   - Everwin Muntinlupa', NULL, 1, '2026-10-20 09:38:35'),
(441, 'Kemp Group:Daily Value   Marketing Corporation', NULL, 1, '2026-10-20 09:38:35'),
(442, 'Kemp Group:Chan, Rey Kenneth   Go', NULL, 1, '2026-10-20 09:38:35'),
(443, 'Kemp Group:Wong Raymark Chan -   Blumentritt', NULL, 1, '2026-10-20 09:38:35'),
(444, 'Kemp Group:Chan Rey Kenneth Go   - Everwin Malolos', NULL, 1, '2026-10-20 09:38:35'),
(445, 'Kemp Group:Chan, Rey Kenneth   Go - Everwin Cavite', NULL, 1, '2026-10-20 09:38:35'),
(446, 'Kemp Group:Wong Ray Mark Chan   - Glee Mart Gua Gua', NULL, 1, '2026-10-20 09:38:35'),
(447, 'Kemp Group:Wong Ray Mark Chan   - Glee Mart Marikina', NULL, 1, '2026-10-20 09:38:35'),
(448, 'Kemp Group:Wong Raymond Chan -   Frisco', NULL, 1, '2026-10-20 09:38:35'),
(449, 'Kemp Group:Wong Raymond Chan -   Kemp Mart Caloocan', NULL, 1, '2026-10-20 09:38:35'),
(450, 'Kemp Group:Wong Raymond Chan -   Kemp Mart Silang', NULL, 1, '2026-10-20 09:38:35'),
(451, 'Kemp Group:Wong Raymond Chan   Kemp Mart Arayat', NULL, 1, '2026-10-20 09:38:35'),
(452, 'Kemp Group:Wong, Bunsiok Chan   - Sampaloc', NULL, 1, '2026-10-20 09:38:35'),
(453, 'Kendrick Go', NULL, 1, '2026-10-20 09:38:35'),
(454, 'Kenny Chua', NULL, 1, '2026-10-20 09:38:35'),
(455, 'Kenya Mendoza', NULL, 1, '2026-10-20 09:38:35'),
(456, 'Khate and Carl', NULL, 1, '2026-10-20 09:38:35'),
(457, 'KHRISTINE VILLAMIN', NULL, 1, '2026-10-20 09:38:35'),
(458, 'KICK STAND CAFE', NULL, 1, '2026-10-20 09:38:35'),
(459, 'Killion', NULL, 1, '2026-10-20 09:38:35'),
(460, 'Killion Merchandising Corp.', NULL, 1, '2026-10-20 09:38:35'),
(461, 'KJML Store', NULL, 1, '2026-10-20 09:38:35'),
(462, 'Komunidad PH Events', NULL, 1, '2026-10-20 09:38:35'),
(463, 'KOR Asian Enterprises Inc.', NULL, 1, '2026-10-20 09:38:35'),
(464, 'Kristine Dino', NULL, 1, '2026-10-20 09:38:35'),
(465, 'KUHN ARTISANALES INC.', NULL, 1, '2026-10-20 09:38:35'),
(466, 'Kyle Frozen Food', NULL, 1, '2026-10-20 09:38:35'),
(467, 'La Toca', NULL, 1, '2026-10-20 09:38:35'),
(468, 'La Virgina Ristorante Inc.', NULL, 1, '2026-10-20 09:38:35'),
(469, 'Landmark', NULL, 1, '2026-10-20 09:38:35'),
(470, 'Landmark:City Super Alabang   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(471, 'Landmark:City Super   Incorporated', NULL, 1, '2026-10-20 09:38:35'),
(472, 'Landmark:City Super Nuvali   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(473, 'Landmark:The Landmark   Corporation-BGC', NULL, 1, '2026-10-20 09:38:35'),
(474, 'Landmark:The Landmark   Corporation', NULL, 1, '2026-10-20 09:38:35'),
(475, 'Landmark:The Landmark Manila   Bay', NULL, 1, '2026-10-20 09:38:35'),
(476, 'Lazo Odalyn Boneza', NULL, 1, '2026-10-20 09:38:35'),
(477, 'LCC', NULL, 1, '2026-10-20 09:38:35'),
(478, 'LCC:Libertad Consumer   Corp.-Pili Capital', NULL, 1, '2026-10-20 09:38:35'),
(479, 'LCC:La Consumidores Corp.', NULL, 1, '2026-10-20 09:38:35'),
(480, 'LCC:LIBERTAD CONSUMERS CORP.', NULL, 1, '2026-10-20 09:38:35'),
(481, 'LCC:Libertad Cosumers   Corporation', NULL, 1, '2026-10-20 09:38:35'),
(482, 'LCC:LION COMMERCIAL   CORPORATION', NULL, 1, '2026-10-20 09:38:35'),
(483, 'LCC:LION COMMERCIAL   CORPORATION - CENTRO POB.', NULL, 1, '2026-10-20 09:38:35'),
(484, 'LCC:Shopmore Commercial   Corporation', NULL, 1, '2026-10-20 09:38:35'),
(485, 'LCC:Shoprich Marketsavers Inc.', NULL, 1, '2026-10-20 09:38:35'),
(486, 'Le Professional Foodservice   Concepts Inc', NULL, 1, '2026-10-20 09:38:35'),
(487, 'Leony Frozen Food', NULL, 1, '2026-10-20 09:38:35'),
(488, 'Level Up KTV Billiards', NULL, 1, '2026-10-20 09:38:35'),
(489, 'Lg Food Mktg.Inc.', NULL, 1, '2026-10-20 09:38:35'),
(490, 'LIBERTAD TOURIST DEVELOPMENT   INC.', NULL, 1, '2026-10-20 09:38:35'),
(491, 'Liezel and Zaldy', NULL, 1, '2026-10-20 09:38:35'),
(492, 'LILJ Marketing', NULL, 1, '2026-10-20 09:38:35'),
(493, 'Linda Store', NULL, 1, '2026-10-20 09:38:35'),
(494, 'Ling Ling', NULL, 1, '2026-10-20 09:38:35'),
(495, 'LION COMMERCIAL CORPORATION -   PEÑARANDA', NULL, 1, '2026-10-20 09:38:35'),
(496, 'LION COMMERCIAL CORPORATION -   QUEZON AVE', NULL, 1, '2026-10-20 09:38:35'),
(497, 'LION COMMERCIAL CORPORATION -   ZIGA  AVE.', NULL, 1, '2026-10-20 09:38:35'),
(498, 'Lito - Hauler', NULL, 1, '2026-10-20 09:38:35'),
(499, 'Liza Pili Store', NULL, 1, '2026-10-20 09:38:35'),
(500, 'LM ENT Consumer goods   wholesaling', NULL, 1, '2026-10-20 09:38:35'),
(501, 'LMB GROCERY', NULL, 1, '2026-10-20 09:38:35'),
(502, 'Lourdes Store', NULL, 1, '2026-10-20 09:38:35'),
(503, 'LS8888', NULL, 1, '2026-10-20 09:38:35'),
(504, 'LSP Marketing', NULL, 1, '2026-10-20 09:38:35'),
(505, 'LYKA SAGUN', NULL, 1, '2026-10-20 09:38:35'),
(506, 'LZV FOODOPHILE FOOD SERVICES', NULL, 1, '2026-10-20 09:38:35'),
(507, 'M.C.Y', NULL, 1, '2026-10-20 09:38:35'),
(508, 'Ma\'am Irene', NULL, 1, '2026-10-20 09:38:35'),
(509, 'Ma\'am Josie', NULL, 1, '2026-10-20 09:38:35'),
(510, 'Ma. Charlene Sheryl Ann   Batanes', NULL, 1, '2026-10-20 09:38:35'),
(511, 'Mac and Wendy Dy', NULL, 1, '2026-10-20 09:38:35'),
(512, 'Mac Frozen Food', NULL, 1, '2026-10-20 09:38:35'),
(513, 'Made Nice Inc.', NULL, 1, '2026-10-20 09:38:35'),
(514, 'Mae Cunanan', NULL, 1, '2026-10-20 09:38:35'),
(515, 'Mai Mai Frozen Goods', NULL, 1, '2026-10-20 09:38:35'),
(516, 'Makati Shangri-la Hotel and   Resort Incorp', NULL, 1, '2026-10-20 09:38:35'),
(517, 'Malabanan, Ma.Gina Guiruela', NULL, 1, '2026-10-20 09:38:35'),
(518, 'Mam Ana Gascon', NULL, 1, '2026-10-20 09:38:35'),
(519, 'MAM CAMILLE ENGCO', NULL, 1, '2026-10-20 09:38:35'),
(520, 'Mam Cecille Padua', NULL, 1, '2026-10-20 09:38:35'),
(521, 'Mam Dar', NULL, 1, '2026-10-20 09:38:35'),
(522, 'Mam Dar (Toplis)', NULL, 1, '2026-10-20 09:38:35'),
(523, 'Mam Emma', NULL, 1, '2026-10-20 09:38:35'),
(524, 'Mam Gina Lim', NULL, 1, '2026-10-20 09:38:35'),
(525, 'Mam Joan', NULL, 1, '2026-10-20 09:38:35'),
(526, 'Mam Maleen', NULL, 1, '2026-10-20 09:38:35'),
(527, 'Mam Mar Tan', NULL, 1, '2026-10-20 09:38:35'),
(528, 'Mam Michelle Pallarco', NULL, 1, '2026-10-20 09:38:35'),
(529, 'Mam Mimi', NULL, 1, '2026-10-20 09:38:35'),
(530, 'MAM PINKY', NULL, 1, '2026-10-20 09:38:35'),
(531, 'Man Yu So', NULL, 1, '2026-10-20 09:38:35'),
(532, 'Mang Juan Franchise', NULL, 1, '2026-10-20 09:38:35'),
(533, 'MANILA GRAND OPERA HOTEL', NULL, 1, '2026-10-20 09:38:35'),
(534, 'Manila Marriott Hotel', NULL, 1, '2026-10-20 09:38:35'),
(535, 'MANLA WHILGOLD', NULL, 1, '2026-10-20 09:38:35'),
(536, 'Manny Guarin (KAP)', NULL, 1, '2026-10-20 09:38:35'),
(537, 'Wallace', NULL, 1, '2026-10-20 09:38:35'),
(538, 'Mar Frozen Food', NULL, 1, '2026-10-20 09:38:35'),
(539, 'Mar Frozen Food (Bacoor)', NULL, 1, '2026-10-20 09:38:35'),
(540, 'Mara Francheska Samarista', NULL, 1, '2026-10-20 09:38:35'),
(541, 'Marby', NULL, 1, '2026-10-20 09:38:35'),
(542, 'Marby Food Ventures Corp.', NULL, 1, '2026-10-20 09:38:35'),
(543, 'Marcos,Analie Madrid-Matt-Matt   Marketing', NULL, 1, '2026-10-20 09:38:35'),
(544, 'MARGA CRUZ', NULL, 1, '2026-10-20 09:38:35'),
(545, 'Maribeth Yeung', NULL, 1, '2026-10-20 09:38:35'),
(546, 'Maricel - Kadiwa', NULL, 1, '2026-10-20 09:38:35'),
(547, 'Maricon Mendoza', NULL, 1, '2026-10-20 09:38:35'),
(548, 'Mariel Dizon', NULL, 1, '2026-10-20 09:38:35'),
(549, 'MARU PANGASNAN', NULL, 1, '2026-10-20 09:38:35'),
(550, 'Mary Liza', NULL, 1, '2026-10-20 09:38:35'),
(551, 'Mav\'s Burger', NULL, 1, '2026-10-20 09:38:35'),
(552, 'Mayie\'s Meatshop', NULL, 1, '2026-10-20 09:38:35'),
(553, 'MCS (Michelle Siervo)', NULL, 1, '2026-10-20 09:38:35'),
(554, 'McWilson Corp.', NULL, 1, '2026-10-20 09:38:35'),
(555, 'Meathub (J. Bañez)', NULL, 1, '2026-10-20 09:38:35'),
(556, 'MEET MY MEAT - THE FROZEN   CAPITAL', NULL, 1, '2026-10-20 09:38:35'),
(557, 'Mega C Food Store', NULL, 1, '2026-10-20 09:38:35'),
(558, 'Mel & Fani Store', NULL, 1, '2026-10-20 09:38:35'),
(559, 'Melan Store', NULL, 1, '2026-10-20 09:38:35'),
(560, 'Melissa Limcaoco', NULL, 1, '2026-10-20 09:38:35'),
(561, 'MERC Braga Meat Products   Trading', NULL, 1, '2026-10-20 09:38:35'),
(562, 'Mercy & Melleth   Enterprises', NULL, 1, '2026-10-20 09:38:35'),
(563, 'MET-Gaspar', NULL, 1, '2026-10-20 09:38:35'),
(564, 'MET - Cris', NULL, 1, '2026-10-20 09:38:35'),
(565, 'MET food Office', NULL, 1, '2026-10-20 09:38:35'),
(566, 'MET Food Q.C Warehouse', NULL, 1, '2026-10-20 09:38:35'),
(567, 'Metro Gallery', NULL, 1, '2026-10-20 09:38:35'),
(568, 'MFood Ventures Corp.', NULL, 1, '2026-10-20 09:38:35'),
(569, 'MFR FOODS CORP.', NULL, 1, '2026-10-20 09:38:35'),
(570, 'Mia Bella Corporation', NULL, 1, '2026-10-20 09:38:35'),
(571, 'Stefan Becker ( TGH the   Grillhouse )', NULL, 1, '2026-10-20 09:38:35'),
(572, 'MICHELLE DEL ROSARIO', NULL, 1, '2026-10-20 09:38:35'),
(573, 'Michelle Tanking', NULL, 1, '2026-10-20 09:38:35'),
(574, 'ML FOODSTUFF', NULL, 1, '2026-10-20 09:38:35'),
(575, 'MLE Frozen Product Trading', NULL, 1, '2026-10-20 09:38:35'),
(576, 'Modern Tradition Restaurant   Group Corp', NULL, 1, '2026-10-20 09:38:35'),
(577, 'Mommy Loida Food OPC', NULL, 1, '2026-10-20 09:38:35'),
(578, 'Mon Malonzo', NULL, 1, '2026-10-20 09:38:35'),
(579, 'Monster Burger', NULL, 1, '2026-10-20 09:38:35'),
(580, 'Montero\'s Store', NULL, 1, '2026-10-20 09:38:35'),
(581, 'MOOD', NULL, 1, '2026-10-20 09:38:35'),
(582, 'Mr. Patatas', NULL, 1, '2026-10-20 09:38:35'),
(583, 'Mr. Potato', NULL, 1, '2026-10-20 09:38:35'),
(584, 'Mr. Potatoes Fries Station', NULL, 1, '2026-10-20 09:38:35'),
(585, 'Municipality Sual', NULL, 1, '2026-10-20 09:38:35'),
(586, 'Myhel Food Distribution', NULL, 1, '2026-10-20 09:38:35'),
(587, 'Mylene Madrigal', NULL, 1, '2026-10-20 09:38:35'),
(588, 'MYLYN', NULL, 1, '2026-10-20 09:38:35'),
(589, 'Myron & Lorraine Food Shop', NULL, 1, '2026-10-20 09:38:35'),
(590, 'Napoleon Ong', NULL, 1, '2026-10-20 09:38:35'),
(591, 'Naz Acain', NULL, 1, '2026-10-20 09:38:35'),
(592, 'Nazzaire\'s Cold Storage', NULL, 1, '2026-10-20 09:38:35'),
(593, 'Neal Matthew Uy', NULL, 1, '2026-10-20 09:38:35'),
(594, 'Neil Jhansen Javier', NULL, 1, '2026-10-20 09:38:35'),
(595, 'Nelia Store', NULL, 1, '2026-10-20 09:38:35'),
(596, 'Nelly Camacho', NULL, 1, '2026-10-20 09:38:35'),
(597, 'Nelson Ramillo', NULL, 1, '2026-10-20 09:38:35'),
(598, 'NENZO FOOD CORP.', NULL, 1, '2026-10-20 09:38:35'),
(599, 'NEPO MINI MART', NULL, 1, '2026-10-20 09:38:35'),
(600, 'New Coast Hotel, Inc.', NULL, 1, '2026-10-20 09:38:35'),
(601, 'New Señorito Frozen Food', NULL, 1, '2026-10-20 09:38:35'),
(602, 'NG Chain Group', NULL, 1, '2026-10-20 09:38:35'),
(603, 'NG Chain Group:Alabang   Supermarket Corporation', NULL, 1, '2026-10-20 09:38:35'),
(604, 'NG Chain Group:UM Superfoods   Corp.', NULL, 1, '2026-10-20 09:38:35'),
(605, 'NG Chain Group:Unimart   Incorporated', NULL, 1, '2026-10-20 09:38:35'),
(606, 'Nhel & Yen Store', NULL, 1, '2026-10-20 09:38:35'),
(607, 'NICON Services Corporation', NULL, 1, '2026-10-20 09:38:35'),
(608, 'Nito\'s Enterprises', NULL, 1, '2026-10-20 09:38:35'),
(609, 'NO BIA, INC.', NULL, 1, '2026-10-20 09:38:35'),
(610, 'Noble House Business Brokers   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(611, 'Northpoint Inc.', NULL, 1, '2026-10-20 09:38:35'),
(612, 'noted', NULL, 1, '2026-10-20 09:38:35'),
(613, 'O-Time Milktea & Coffee   Snack House', NULL, 1, '2026-10-20 09:38:35'),
(614, 'Odeth', NULL, 1, '2026-10-20 09:38:35'),
(615, 'One 4 All Food Solutions OPC', NULL, 1, '2026-10-20 09:38:35'),
(616, 'One 8 One Cafe & Resto', NULL, 1, '2026-10-20 09:38:35'),
(617, 'OUI Meema Cafe OPC', NULL, 1, '2026-10-20 09:38:35'),
(618, 'Pacific', NULL, 1, '2026-10-20 09:38:35'),
(619, 'Pasig Supermarket Inc.', NULL, 1, '2026-10-20 09:38:35'),
(620, 'Pastil King', NULL, 1, '2026-10-20 09:38:35'),
(621, 'Pat Store', NULL, 1, '2026-10-20 09:38:35'),
(622, 'Perry Jane Viray', NULL, 1, '2026-10-20 09:38:35'),
(623, 'Philippine Seven Corporation', NULL, 1, '2026-10-20 09:38:35'),
(624, 'PHYSICAL DISTRIBUTION NETWORK   INC.', NULL, 1, '2026-10-20 09:38:35'),
(625, 'Pia Sagario Vera Cruz', NULL, 1, '2026-10-20 09:38:35'),
(626, 'Poleng Cabasag', NULL, 1, '2026-10-20 09:38:35'),
(627, 'Popperuu', NULL, 1, '2026-10-20 09:38:35'),
(628, 'Pouf Inc', NULL, 1, '2026-10-20 09:38:35'),
(629, 'PPCI Warehouse 1', NULL, 1, '2026-10-20 09:38:35'),
(630, 'Precy Store', NULL, 1, '2026-10-20 09:38:35'),
(631, 'President\'s Bar   Steakhouse-ACCI', NULL, 1, '2026-10-20 09:38:35'),
(632, 'Prime Asia Consolidators Inc.', NULL, 1, '2026-10-20 09:38:35'),
(633, 'Prime Foodlab Innovation Inc.', NULL, 1, '2026-10-20 09:38:35'),
(634, 'Princess Arnel Store', NULL, 1, '2026-10-20 09:38:35'),
(635, 'Pronto NL Distribution Inc.', NULL, 1, '2026-10-20 09:38:35'),
(636, 'Proyectos Corp.', NULL, 1, '2026-10-20 09:38:35'),
(637, 'Psalm E Frozen store', NULL, 1, '2026-10-20 09:38:35'),
(638, 'Puregold Duty Free Subic, Inc', NULL, 1, '2026-10-20 09:38:35'),
(639, 'Puregold DutyFree Inc.', NULL, 1, '2026-10-20 09:38:35'),
(640, 'Puregold Price Club Inc.', NULL, 1, '2026-10-20 09:38:35'),
(641, 'Queenie Inocencio', NULL, 1, '2026-10-20 09:38:35'),
(642, 'Queenie Mangabat', NULL, 1, '2026-10-20 09:38:35'),
(643, 'Quisine Masters Corp.', NULL, 1, '2026-10-20 09:38:35'),
(644, 'R & Joyce Food Products   Mktg', NULL, 1, '2026-10-20 09:38:35'),
(645, 'RACS Group Ventures Co. Inc.', NULL, 1, '2026-10-20 09:38:35'),
(646, 'Rafaelo Lim', NULL, 1, '2026-10-20 09:38:35'),
(647, 'Ramon Rubio', NULL, 1, '2026-10-20 09:38:35'),
(648, 'Raohe Group Corp.', NULL, 1, '2026-10-20 09:38:35'),
(649, 'Raymart Tulod', NULL, 1, '2026-10-20 09:38:35'),
(650, 'RAYMUND LEGASPI', NULL, 1, '2026-10-20 09:38:35'),
(651, 'Razelyn Rivera', NULL, 1, '2026-10-20 09:38:35'),
(652, 'RB Corporate Services Inc.', NULL, 1, '2026-10-20 09:38:35'),
(653, 'RBT Seafoods', NULL, 1, '2026-10-20 09:38:35'),
(654, 'RCCM Chicken Trading', NULL, 1, '2026-10-20 09:38:35'),
(655, 'RCLABIO Varity Store', NULL, 1, '2026-10-20 09:38:35'),
(656, 'RDBA Marketing', NULL, 1, '2026-10-20 09:38:35'),
(657, 'Reat\'s Food Services', NULL, 1, '2026-10-20 09:38:35'),
(658, 'Rebecca Jan Daigle', NULL, 1, '2026-10-20 09:38:35'),
(659, 'Regie Dino', NULL, 1, '2026-10-20 09:38:35'),
(660, 'Regina\'s Catering', NULL, 1, '2026-10-20 09:38:35'),
(661, 'Reina Store', NULL, 1, '2026-10-20 09:38:35'),
(662, 'Reison Ang', NULL, 1, '2026-10-20 09:38:35'),
(663, 'REL\'s Consumables and Food   Supply Trading', NULL, 1, '2026-10-20 09:38:35'),
(664, 'REMJR Corporation', NULL, 1, '2026-10-20 09:38:35'),
(665, 'REMJR Zapote', NULL, 1, '2026-10-20 09:38:35'),
(666, 'Restaurant Collective,Inc.', NULL, 1, '2026-10-20 09:38:35'),
(667, 'Retchel Frozen', NULL, 1, '2026-10-20 09:38:35'),
(668, 'REYNOLD\'S FOOD & BEVERAGES', NULL, 1, '2026-10-20 09:38:35'),
(669, 'RGM Frozen Food', NULL, 1, '2026-10-20 09:38:35'),
(670, 'Ria Cruz', NULL, 1, '2026-10-20 09:38:35'),
(671, 'Richard Arcas', NULL, 1, '2026-10-20 09:38:35'),
(672, 'RICHELLE GUTIERREZ', NULL, 1, '2026-10-20 09:38:35'),
(673, 'Ricky\'s Meat Shop-Caloocan', NULL, 1, '2026-10-20 09:38:35'),
(674, 'Ricky\'s Meat Shop - Valenzuela', NULL, 1, '2026-10-20 09:38:35'),
(675, 'Rita Robles', NULL, 1, '2026-10-20 09:38:35'),
(676, 'Ritzelle Robles Trading', NULL, 1, '2026-10-20 09:38:35'),
(677, 'RJ frozen Goods', NULL, 1, '2026-10-20 09:38:35'),
(678, 'RMBT Corporation', NULL, 1, '2026-10-20 09:38:35'),
(679, 'Rob Pengson', NULL, 1, '2026-10-20 09:38:35'),
(680, 'Robert Socias', NULL, 1, '2026-10-20 09:38:35'),
(681, 'Robinson\'s Nuvali Sta. Rosa', NULL, 1, '2026-10-20 09:38:35'),
(682, 'Robinson\'s Supermarket Corp.', NULL, 1, '2026-10-20 09:38:35'),
(683, 'Robinson\'s Supermarkets', NULL, 1, '2026-10-20 09:38:35'),
(684, 'Robinsons', NULL, 1, '2026-10-20 09:38:35'),
(685, 'Rochelle Bustos', NULL, 1, '2026-10-20 09:38:35'),
(686, 'Rodel & Sonia Castillo   Store', NULL, 1, '2026-10-20 09:38:35'),
(687, 'Romer Dela Cruz', NULL, 1, '2026-10-20 09:38:35'),
(688, 'Romina Gallardo', NULL, 1, '2026-10-20 09:38:35'),
(689, 'Romina Store', NULL, 1, '2026-10-20 09:38:35'),
(690, 'Ronaldo Endaya', NULL, 1, '2026-10-20 09:38:35'),
(691, 'Ronalyn Soledad', NULL, 1, '2026-10-20 09:38:35'),
(692, 'Rooftop Concepts', NULL, 1, '2026-10-20 09:38:35'),
(693, 'Rosanna Seafoods & Frozen   Products', NULL, 1, '2026-10-20 09:38:35'),
(694, 'Royal Inc', NULL, 1, '2026-10-20 09:38:35'),
(695, 'RubyStore', NULL, 1, '2026-10-20 09:38:35'),
(696, 'RUENA CHUA', NULL, 1, '2026-10-20 09:38:35'),
(697, 'Ryan Llanos Dee', NULL, 1, '2026-10-20 09:38:35'),
(698, 'Sai Bugayong', NULL, 1, '2026-10-20 09:38:35'),
(699, 'SANFORD MARKETING CORPORATION', NULL, 1, '2026-10-20 09:38:35'),
(700, 'Sarah Mercado', NULL, 1, '2026-10-20 09:38:35'),
(701, 'Sargo Cafe-Navotas', NULL, 1, '2026-10-20 09:38:35'),
(702, 'Savano Cafe', NULL, 1, '2026-10-20 09:38:35'),
(703, 'Scorched Smokehouse Inc.', NULL, 1, '2026-10-20 09:38:35'),
(704, 'Sean Jersen Tan', NULL, 1, '2026-10-20 09:38:35'),
(705, 'SGDPrime Marketing Inc', NULL, 1, '2026-10-20 09:38:35'),
(706, 'SHAKEY\'S PIZZA ASIA VENTURES   INC.', NULL, 1, '2026-10-20 09:38:35'),
(707, 'Shang Global City Properties   Inc.', NULL, 1, '2026-10-20 09:38:35'),
(708, 'Sharlyn Joy Kabunga', NULL, 1, '2026-10-20 09:38:35'),
(709, 'Shawander Inc.', NULL, 1, '2026-10-20 09:38:35'),
(710, 'Shelo Noval', NULL, 1, '2026-10-20 09:38:35'),
(711, 'SHENZI\'S CAFE', NULL, 1, '2026-10-20 09:38:35'),
(712, 'Shin Perez', NULL, 1, '2026-10-20 09:38:35'),
(713, 'Sir Emman Caedo', NULL, 1, '2026-10-20 09:38:35'),
(714, 'Sir Jonathan Baquiran', NULL, 1, '2026-10-20 09:38:35'),
(715, 'Sir Mannix Dela Peña', NULL, 1, '2026-10-20 09:38:35'),
(716, 'Sir Vic', NULL, 1, '2026-10-20 09:38:35'),
(717, 'SISKO', NULL, 1, '2026-10-20 09:38:35'),
(718, 'SITC', NULL, 1, '2026-10-20 09:38:35'),
(719, 'SM Hypermarket', NULL, 1, '2026-10-20 09:38:35'),
(720, 'SM Hypermarket:SM Hypermarket   - Antipolo', NULL, 1, '2026-10-20 09:38:35'),
(721, 'SM Hypermarket:SM Hypermarket   - Baliuag', NULL, 1, '2026-10-20 09:38:35'),
(722, 'SM Hypermarket:SM Hypermarket   - Bicutan', NULL, 1, '2026-10-20 09:38:35'),
(723, 'SM Hypermarket:SM Hypermarket   - Cainta', NULL, 1, '2026-10-20 09:38:35'),
(724, 'SM Hypermarket:SM Hypermarket   - Capiz', NULL, 1, '2026-10-20 09:38:35'),
(725, 'SM Hypermarket:SM Hypermarket   - Cebu', NULL, 1, '2026-10-20 09:38:35'),
(726, 'SM Hypermarket:SM Hypermarket   - Cherry Congressional', NULL, 1, '2026-10-20 09:38:35'),
(727, 'SM Hypermarket:SM Hypermarket   - Clark', NULL, 1, '2026-10-20 09:38:35'),
(728, 'SM Hypermarket:SM Hypermarket   - Cubao', NULL, 1, '2026-10-20 09:38:35'),
(729, 'SM Hypermarket:SM Hypermarket   - Daet', NULL, 1, '2026-10-20 09:38:35'),
(730, 'SM Hypermarket:SM Hypermarket   - Dasma', NULL, 1, '2026-10-20 09:38:35'),
(731, 'SM Hypermarket:SM Hypermarket   - Fairview', NULL, 1, '2026-10-20 09:38:35'),
(732, 'SM Hypermarket:SM Hypermarket   - FTI', NULL, 1, '2026-10-20 09:38:35'),
(733, 'SM Hypermarket:SM Hypermarket   - Handumanan', NULL, 1, '2026-10-20 09:38:35'),
(734, 'SM Hypermarket:SM Hypermarket   - Ilo ilo', NULL, 1, '2026-10-20 09:38:35'),
(735, 'SM Hypermarket:SM Hypermarket   - J MAll', NULL, 1, '2026-10-20 09:38:35'),
(736, 'SM Hypermarket:SM Hypermarket   - Jazz', NULL, 1, '2026-10-20 09:38:35'),
(737, 'SM Hypermarket:SM Hypermarket   - Lapu lapu', NULL, 1, '2026-10-20 09:38:35'),
(738, 'SM Hypermarket:SM Hypermarket   - Las Piñas', NULL, 1, '2026-10-20 09:38:35'),
(739, 'SM Hypermarket:SM Hypermarket   - Makati', NULL, 1, '2026-10-20 09:38:35'),
(740, 'SM Hypermarket:SM Hypermarket   - Mall of Asia', NULL, 1, '2026-10-20 09:38:35'),
(741, 'SM Hypermarket:SM Hypermarket   - Mandaluyong', NULL, 1, '2026-10-20 09:38:35'),
(742, 'SM Hypermarket:SM Hypermarket   - Marilao', NULL, 1, '2026-10-20 09:38:35'),
(743, 'SM Hypermarket:SM Hypermarket   - Molino', NULL, 1, '2026-10-20 09:38:35'),
(744, 'SM Hypermarket:SM Hypermarket   - Muntinlupa', NULL, 1, '2026-10-20 09:38:35'),
(745, 'SM Hypermarket:SM Hypermarket   - North Edsa', NULL, 1, '2026-10-20 09:38:35'),
(746, 'SM Hypermarket:SM Hypermarket   - Novaliches', NULL, 1, '2026-10-20 09:38:35'),
(747, 'SM Hypermarket:SM Hypermarket   - Sucat', NULL, 1, '2026-10-20 09:38:35'),
(748, 'SM Hypermarket:SM Hypermarket   - Sucat Lopez', NULL, 1, '2026-10-20 09:38:35'),
(749, 'SM Hypermarket:SM Hypermarket   - Taytay', NULL, 1, '2026-10-20 09:38:35'),
(750, 'SM Hypermarket:SM Hypermarket   - The Village Square', NULL, 1, '2026-10-20 09:38:35'),
(751, 'SM Hypermarket:SM Hypermarket   - Valenzuela', NULL, 1, '2026-10-20 09:38:35'),
(752, 'SM Hypermarket:SM Hypermarket   - Xentro Mall', NULL, 1, '2026-10-20 09:38:35'),
(753, 'SM Hypermarket:SM Hypermarket   Mandaluyong', NULL, 1, '2026-10-20 09:38:35'),
(754, 'SM Hypermarket - Pasig', NULL, 1, '2026-10-20 09:38:35'),
(755, 'SMOOSH N\' BREW', NULL, 1, '2026-10-20 09:38:35'),
(756, 'Snackets Convenience Shop', NULL, 1, '2026-10-20 09:38:35'),
(757, 'SNR food Services', NULL, 1, '2026-10-20 09:38:35'),
(758, 'SODEXO Onsites Philippines', NULL, 1, '2026-10-20 09:38:35'),
(759, 'Sofisticato Kitchenette', NULL, 1, '2026-10-20 09:38:35'),
(760, 'Solid Snow Frozen Foods', NULL, 1, '2026-10-20 09:38:35'),
(761, 'SOPHIA MADRIAGA', NULL, 1, '2026-10-20 09:38:35'),
(762, 'Sostanza Inc.', NULL, 1, '2026-10-20 09:38:35'),
(763, 'Southbank Capcom Corporation', NULL, 1, '2026-10-20 09:38:35'),
(764, 'Southduo Consumer Goods   Trading', NULL, 1, '2026-10-20 09:38:35'),
(765, 'Special Event', NULL, 1, '2026-10-20 09:38:35'),
(766, 'SRA', NULL, 1, '2026-10-20 09:38:35'),
(767, 'SS Super Rama, Inc', NULL, 1, '2026-10-20 09:38:35'),
(768, 'Stassen & Co., Inc.', NULL, 1, '2026-10-20 09:38:35'),
(769, 'Steak Room Concepts,Inc.', NULL, 1, '2026-10-20 09:38:35'),
(770, 'Steakation Grill House', NULL, 1, '2026-10-20 09:38:35'),
(771, 'Sun Cafe', NULL, 1, '2026-10-20 09:38:35'),
(772, 'Sunshine Escaro', NULL, 1, '2026-10-20 09:38:35'),
(773, 'Super Mom\'s Pizza', NULL, 1, '2026-10-20 09:38:35'),
(774, 'Super Shopping Market Inc.', NULL, 1, '2026-10-20 09:38:35'),
(775, 'Supervalue, Inc.', NULL, 1, '2026-10-20 09:38:35'),
(776, 'Susan Bragado', NULL, 1, '2026-10-20 09:38:35'),
(777, 'SV', NULL, 1, '2026-10-20 09:38:35'),
(778, 'Swiss Pizza Hub', NULL, 1, '2026-10-20 09:38:35'),
(779, 'Takoyehey', NULL, 1, '2026-10-20 09:38:35'),
(780, 'Tata Ong', NULL, 1, '2026-10-20 09:38:35'),
(781, 'TCS-Crib', NULL, 1, '2026-10-20 09:38:35'),
(782, 'THE BEECH', NULL, 1, '2026-10-20 09:38:35'),
(783, 'The Elevate Group of   Restaurant Inc.', NULL, 1, '2026-10-20 09:38:35'),
(784, 'THE FARM AT CARPENTER   HILL,INC.', NULL, 1, '2026-10-20 09:38:35'),
(785, 'The Happy Foodie Restaurant   Corp.', NULL, 1, '2026-10-20 09:38:35'),
(786, 'Thea & Noel', NULL, 1, '2026-10-20 09:38:35'),
(787, 'THIGH JOINT FOOD CORPORATION', NULL, 1, '2026-10-20 09:38:35'),
(788, 'Tita Meryll Food Shop 1', NULL, 1, '2026-10-20 09:38:35'),
(789, 'Toplis Employee', NULL, 1, '2026-10-20 09:38:35'),
(790, 'TOURIST ACCOMODATION   DEVELOPMENT INC.', NULL, 1, '2026-10-20 09:38:35'),
(791, 'Tri Jems Legacy Inc.', NULL, 1, '2026-10-20 09:38:35'),
(792, 'Triple KC Food Services', NULL, 1, '2026-10-20 09:38:35'),
(793, 'Tyler\'s Cafe', NULL, 1, '2026-10-20 09:38:35'),
(794, 'Upland Distribution Inc.', NULL, 1, '2026-10-20 09:38:35'),
(795, 'Vanessa Trinidad', NULL, 1, '2026-10-20 09:38:35'),
(796, 'VBR Genaral Merchandise', NULL, 1, '2026-10-20 09:38:35'),
(797, 'Veronica Yalung', NULL, 1, '2026-10-20 09:38:35'),
(798, 'Vic Tesalona', NULL, 1, '2026-10-20 09:38:35'),
(799, 'Vicente Uy', NULL, 1, '2026-10-20 09:38:35'),
(800, 'Victor Manuel', NULL, 1, '2026-10-20 09:38:35'),
(801, 'Vien General Merchandise', NULL, 1, '2026-10-20 09:38:35'),
(802, 'Virginia Dacia', NULL, 1, '2026-10-20 09:38:35'),
(803, 'Viz-Ra Enterprises Corporation', NULL, 1, '2026-10-20 09:38:35');
INSERT INTO `clients` (`id`, `client_name`, `qb_list_id`, `active`, `created_at`) VALUES
(804, 'Waltermart Supermarket Inc.', NULL, 1, '2026-10-20 09:38:35'),
(805, 'Waltermitty Food Corp.', NULL, 1, '2026-10-20 09:38:35'),
(806, 'Wang Chocolate Inc.', NULL, 1, '2026-10-20 09:38:35'),
(807, 'Weslee Tan', NULL, 1, '2026-10-20 09:38:35'),
(808, 'WHC Food Corner', NULL, 1, '2026-10-20 09:38:35'),
(809, 'WHITE DRAGON TAIWAN MILKTEA', NULL, 1, '2026-10-20 09:38:35'),
(810, 'Wholesale Commodity and   Exchange Inc.', NULL, 1, '2026-10-20 09:38:35'),
(811, 'Willy Ang', NULL, 1, '2026-10-20 09:38:35'),
(812, 'Wilop Food Trader', NULL, 1, '2026-10-20 09:38:35'),
(813, 'WINTER PASANA', NULL, 1, '2026-10-20 09:38:35'),
(814, 'Wokaffe', NULL, 1, '2026-10-20 09:38:35'),
(815, 'Yanni\'s Meat Shop', NULL, 1, '2026-10-20 09:38:35'),
(816, 'YK Fur Friends', NULL, 1, '2026-10-20 09:38:35'),
(817, 'Yvonne Yao', NULL, 1, '2026-10-20 09:38:35'),
(818, 'Zhong Xin Food and Beverages   Trading', NULL, 1, '2026-10-20 09:38:35'),
(819, 'Zirconia Inc.', NULL, 1, '2026-10-20 09:38:35');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('Admin','Employee') NOT NULL DEFAULT 'Employee',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `full_name`, `username`, `password_hash`, `role`, `active`, `created_at`, `updated_at`) VALUES
(1, 'Erich Merilles', 'MFC-tech', '$2y$10$fqSLxQ3TZzZEDWGzachn9OgKt.wpL77ZTzpxITOTIbVcKfWi6Pj62', 'Admin', 1, '2026-10-13 08:49:56', NULL),
(2, 'john', 'john', '$2y$10$aBY1AB/U3MIxoZC3in38x.eBcmpknwPOF/nQoxHlmz28r5.rtwci2', 'Employee', 1, '2026-10-13 10:36:47', NULL),
(3, 'Allen', 'mfc-allen', '$2y$10$oa.OUqiRN9kS/x9zos/ohuQzcahREHQpiHU2.PCKOfcQmJ.qMqsi.', 'Employee', 1, '2026-10-20 10:19:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `employee_permissions`
--

CREATE TABLE `employee_permissions` (
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `permission_code` varchar(80) NOT NULL,
  `granted_by` bigint(20) UNSIGNED DEFAULT NULL,
  `granted_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `withdrawal_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `invoice_number` varchar(100) DEFAULT NULL,
  `invoice_date` date NOT NULL,
  `po_no` varchar(100) DEFAULT NULL,
  `memo` text DEFAULT NULL,
  `status` enum('Draft','Ready','Queued','Processing','Invoiced','Error','Uncertain Result') NOT NULL DEFAULT 'Draft',
  `qb_invoice_no` varchar(100) DEFAULT NULL,
  `qb_txn_id` varchar(100) DEFAULT NULL,
  `submitted_by` bigint(20) UNSIGNED DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `withdrawal_id`, `customer_id`, `invoice_number`, `invoice_date`, `po_no`, `memo`, `status`, `qb_invoice_no`, `qb_txn_id`, `submitted_by`, `submitted_at`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(12, 16, 656, 'LF11770', '2026-10-21', NULL, NULL, 'Draft', NULL, NULL, NULL, NULL, 1, 1, '2026-10-21 08:49:19', '2026-10-21 08:49:46');

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invoice_id` bigint(20) UNSIGNED NOT NULL,
  `withdrawal_item_id` bigint(20) UNSIGNED DEFAULT NULL,
  `source_type` enum('WITHDRAWAL','ADDITIONAL') NOT NULL DEFAULT 'WITHDRAWAL',
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `site_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` bigint(20) UNSIGNED NOT NULL,
  `lot_number` varchar(100) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `u_m` varchar(40) DEFAULT NULL,
  `price_each` decimal(12,2) NOT NULL DEFAULT 0.00,
  `amount` decimal(14,2) NOT NULL DEFAULT 0.00,
  `tax_code` varchar(40) NOT NULL DEFAULT 'Non',
  `expiration_date` date DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoice_items`
--

INSERT INTO `invoice_items` (`id`, `invoice_id`, `withdrawal_item_id`, `source_type`, `product_id`, `site_id`, `product_name`, `quantity`, `lot_number`, `item_code`, `description`, `u_m`, `price_each`, `amount`, `tax_code`, `expiration_date`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(28, 12, 37, 'WITHDRAWAL', 533, 2, '7/7 SHOESTRING 1 KILO NEW PACK', 10, NULL, 'LUTCN77ORG10010', 'Lutosa Red Pack 1 x 10 New packaging', NULL, 100.00, 1000.00, 'Non', NULL, 1, 1, '2026-10-21 09:49:45', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `u_m` varchar(40) DEFAULT NULL,
  `default_site_id` bigint(20) UNSIGNED DEFAULT NULL,
  `default_price` decimal(12,2) DEFAULT NULL,
  `kg_per_box` decimal(12,3) DEFAULT NULL,
  `qb_list_id` varchar(100) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `ht_code` varchar(100) DEFAULT NULL,
  `qb_code` varchar(100) DEFAULT NULL,
  `ht_description` varchar(255) DEFAULT NULL,
  `qb_description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `product_name`, `item_code`, `description`, `u_m`, `default_site_id`, `default_price`, `kg_per_box`, `qb_list_id`, `active`, `created_at`, `updated_at`, `ht_code`, `qb_code`, `ht_description`, `qb_description`) VALUES
(471, '7/7 SHOESTRING 1 KILO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '2026-10-16 08:19:02', '2026-10-16 08:57:53', 'HSC045-0001', NULL, '7/7 SHOESTRING 1 KILO', NULL),
(472, 'POTATO NOISETTES', 'LUTBENOIS0254', 'Lutosa Potato Noisettes 2.5kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:41:04', 'HSC045-003', 'LUTBENOIS0254', 'POTATO NOISETTES', 'Lutosa Potato Noisettes 2.5kg'),
(473, '10/10 FS CAJUN', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '2026-10-16 08:19:02', '2026-10-16 08:31:01', 'HSC045-004', NULL, '10/10 FS CAJUN', NULL),
(474, '10/10 STRAIGHTCUT XTRA CRISPY', 'LUTBEFX1010FX0206', 'Lutosa Finest 10/10 Xtra Xrispy 2kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:41:16', 'HSC045-009', 'LUTBEFX1010FX0206', '10/10 STRAIGHTCUT XTRA CRISPY', 'Lutosa Finest 10/10 Xtra Xrispy 2kg'),
(475, '7/7 FINEST SHOESTRING XTRA CRISPY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-010', NULL, '7/7 FINEST SHOESTRING XTRA CRISPY', NULL),
(476, '10/10 STRAIGHTCUT SKIN-ON', 'LUTBE1010SO02504', 'Lutosa Finest 10/10 Straight Cut Skin on 2.5 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:33:02', 'HSC045-012', 'LUTBE1010SO02504', '10/10 STRAIGHTCUT SKIN-ON', 'Lutosa Finest 10/10 Straight Cut Skin on 2.5 kg'),
(477, '14/14 THICK CUT FRIES', 'LUTBE1414SO02504', 'Lutosa Finest 14/14 Straight Cut Skin On 2.5kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:46:25', 'HSC045-013', 'LUTBE1414SO02504', '14/14 THICK CUT FRIES', 'Lutosa Finest 14/14 Straight Cut Skin On 2.5kg'),
(478, '5/5 SKINNY SKIN-ON', 'LUTBE0505FS02504', 'Lutosa Skinny Fries Xtra Crispy Food services 2.5kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:48:02', 'HSC045-015', 'LUTBE0505FS02504', '5/5 SKINNY SKIN-ON', 'Lutosa Skinny Fries Xtra Crispy Food services 2.5kg'),
(479, 'CRUNCHY HASH BROWN', 'LUTBEHBTRI250', 'Lutosa Hashbrown Traingle 2.5kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:53:29', 'HSC045-018', 'LUTBEHBTRI250', 'CRUNCHY HASH BROWN', 'Lutosa Hashbrown Traingle 2.5kg'),
(480, 'CRUNCHY OVAL HASH BROWN', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-019', NULL, 'CRUNCHY OVAL HASH BROWN', NULL),
(481, 'MASHED POTATO', 'LUTBEMASH250', 'Lutosa Mash Potato 2.5 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:45:36', 'HSC045-020', 'LUTBEMASH250', 'MASHED POTATO', 'Lutosa Mash Potato 2.5 kg'),
(482, 'SPICY WEDGES', 'LUTBEWDGTEX2504', 'Lutosa Tex Mex Wedges 2.5 x 4', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:29:33', 'HSC045-022', 'LUTBEWDGTEX2504', 'SPICY WEDGES', 'Lutosa Tex Mex Wedges 2.5 x 4'),
(483, 'POTATO WEDGES', 'LUTBEWDGQTR2504', 'Lutosa Quarter Wedges 2.5 x 4', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:40:22', 'HSC045-023', 'LUTBEWDGQTR2504', 'POTATO WEDGES', 'Lutosa Quarter Wedges 2.5 x 4'),
(484, 'CRINKLE CUT', 'LUTBECRKL2504', 'Lutosa Crinkle Cut 2.5 x 4', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:53:42', 'HSC045-025', 'LUTBECRKL2504', 'CRINKLE CUT', 'Lutosa Crinkle Cut 2.5 x 4'),
(485, 'FROZEN KERNEL CORN', 'CMDCK100', 'Starmax Frozen  Kernel Corn 1 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 11:16:28', 'HSC045-026', 'CMDCK100', 'FROZEN KERNEL CORN', 'Starmax Frozen  Kernel Corn 1 kg'),
(486, '7/7 THIN CUT SHOESTRING', '', 'Lutosa Shoes Strings 400', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:06:18', 'HSC045-027', '', '7/7 THIN CUT SHOESTRING', ''),
(487, '7/7 SHOESTRING 2 KILO CHINA', 'LUTCN77ORG20006', 'Lutosa Orange Pack 2 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:59:52', 'HSC045-028', 'LUTCN77ORG20006', '7/7 SHOESTRING 2 KILO CHINA', 'Lutosa Orange Pack 2 kg'),
(488, 'SAMPLE ITEM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-029', NULL, 'SAMPLE ITEM', NULL),
(489, 'KDHY 7/7 SHOESTRING 2KG', 'KDHY0707200', 'KDHY 7/7 Shoe strings  2 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:46:39', 'HSC045-030', 'KDHY0707200', 'KDHY 7/7 SHOESTRING 2KG', 'KDHY 7/7 Shoe strings  2 kg'),
(490, 'POTATO CRUNCHIES', 'RPLUTCRU0750', 'Lutosa Crunchies 750grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:41:36', 'HSC045-031', 'RPLUTCRU0750', 'POTATO CRUNCHIES', 'Lutosa Crunchies 750grams'),
(491, 'SPICY WEDGES 750G', 'RPLUTWDGTEX0750', 'Lutosa Spicy Wedges 750 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:29:04', 'HSC045-032', 'RPLUTWDGTEX0750', 'SPICY WEDGES 750G', 'Lutosa Spicy Wedges 750 grams'),
(492, 'SEA URCHIN 190G X 40', 'CB0010190G', 'CB Sea Urchin Falvored Balls 190 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:32:09', 'HSC045-034', 'CB0010190G', 'SEA URCHIN 190G X 40', 'CB Sea Urchin Falvored Balls 190 grams'),
(493, 'SALMON FLAVOURED 175G X 40', 'CB0080175G', 'Salmon Ball falvored with Cheese 175 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:34:46', 'HSC045-035', 'CB0080175G', 'SALMON FLAVOURED 175G X 40', 'Salmon Ball falvored with Cheese 175 grams'),
(494, 'WHITE FISHBALL 500gx24', 'CB0090500G', 'White Fishball 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:20:44', 'HSC045-036', 'CB0090500G', 'WHITE FISHBALL 500gx24', 'White Fishball 500 grams'),
(495, 'LUCKY COMBO 5IN1 500gx24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-037', NULL, 'LUCKY COMBO 5IN1 500gx24', NULL),
(496, 'FRIED FISH BALL 500gx24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-038', NULL, 'FRIED FISH BALL 500gx24', NULL),
(497, 'JAPANESE FISH TOFU 160gx40', 'CB0040160G', 'Japanese Fish Tofu 160 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:47:21', 'HSC045-039', 'CB0040160G', 'JAPANESE FISH TOFU 160gx40', 'Japanese Fish Tofu 160 grams'),
(498, 'CUTTLE FISH BALL W/ SQUID INK 1KGX10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-040', NULL, 'CUTTLE FISH BALL W/ SQUID INK 1KGX10', NULL),
(499, 'CUTTLE FISH BALL W/ SQUID INK 160GX40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-041', NULL, 'CUTTLE FISH BALL W/ SQUID INK 160GX40', NULL),
(500, '7/7 FINEST SHOESTRING 1034137-71', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, '1034137-71', NULL, '7/7 FINEST SHOESTRING 1034137-71', NULL),
(501, '7/7 THINCUT SHOESTRING RUSSET', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-043', NULL, '7/7 THINCUT SHOESTRING RUSSET', NULL),
(502, '10/18 STEAK FRIES 2.5KG', 'LUTBE10182504', 'Lutosa Steak Fries 10-18 2.5 x 4', NULL, NULL, NULL, 10.000, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 10:22:01', 'HSC045-042', 'LUTBE10182504', '10/18 STEAK FRIES 2.5KG', 'Lutosa Steak Fries 10-18 2.5 x 4'),
(503, 'KRISSPY CRINKLE CUT 1KG', 'RPLUTCRK100', 'Lutosa Crinkle Cut 1 x 10RPLUTCRK100', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:45:57', 'HSC045-044', 'RPLUTCRK100', 'KRISSPY CRINKLE CUT 1KG', 'Lutosa Crinkle Cut 1 x 10RPLUTCRK100'),
(504, '10/10 CLASSIC CUT FRIES 1KG', 'RPLUT1010100', 'RP Lutosa Classic Cut 10/101kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:23:01', 'HSC045-45', 'RPLUT1010100', '10/10 CLASSIC CUT FRIES 1KG', 'RP Lutosa Classic Cut 10/101kg'),
(505, '10/10 CLASSIC CUT FRIES 2.5KG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-046', NULL, '10/10 CLASSIC CUT FRIES 2.5KG', NULL),
(506, 'SAVEMORE 1KG', 'SVCHN770110', 'Savemore 7/7 Fries 1 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:34:01', 'HSC045-047', 'SVCHN770110', 'SAVEMORE 1KG', 'Savemore 7/7 Fries 1 kg'),
(507, 'SAVEMORE 2KG', 'SVCHN770206', 'Savemore 7/7 Fries 2kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:32:39', 'HSC045-048', 'SVCHN770206', 'SAVEMORE 2KG', 'Savemore 7/7 Fries 2kg'),
(508, 'MIXED VEGGIES 20x500g', 'IQFMIX3340500', 'Mixed Vegetables Corn, carrots & peas 334 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:44:08', 'HSC045-049', 'IQFMIX3340500', 'MIXED VEGGIES 20x500g', 'Mixed Vegetables Corn, carrots & peas 334 500 grams'),
(509, 'CALIFORNIA MIXED', 'IQFCALI050020', 'Yummy California Mix 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:56:26', 'HSC045-050', 'IQFCALI050020', 'CALIFORNIA MIXED', 'Yummy California Mix 500 grams'),
(510, 'MIXED BERRIES', 'IQFMBRS0500', 'Mixed Berries 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:44:48', 'HSC045-051', 'IQFMBRS0500', 'MIXED BERRIES', 'Mixed Berries 500 grams'),
(511, 'SWEET POTATO', 'LUTCNSP10102504', 'Lutosa Sweet Potato 2.5 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:21:37', 'HSC045-052', 'LUTCNSP10102504', 'SWEET POTATO', 'Lutosa Sweet Potato 2.5 kg'),
(512, '10/10 STRAIGHTCUT 2KG CHINA', 'LUTCN1010ST20006', 'Lutosa CN 10/10 Stright Cut 2 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:32:04', 'HSC045-053', 'LUTCN1010ST20006', '10/10 STRAIGHTCUT 2KG CHINA', 'Lutosa CN 10/10 Stright Cut 2 kg'),
(513, 'POTATO NOISETTES 750G', 'RPLUTNOIS75012', 'Lutosa Noisettes 750 grams Retail Pack', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:40:49', 'HSC045-054', 'RPLUTNOIS75012', 'POTATO NOISETTES 750G', 'Lutosa Noisettes 750 grams Retail Pack'),
(514, 'POTATO CROQUETTES 750G', 'RPLUTCROQ75012', 'Lutosa Croquette 750 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:42:01', 'HSC045-055', 'RPLUTCROQ75012', 'POTATO CROQUETTES 750G', 'Lutosa Croquette 750 grams'),
(515, 'HASH BROWN MINI 4 X 2.5 KG', 'LUTBEHBMNTRI250', 'Lutosa Mini Triangle HAshbrown 2.5kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:50:35', 'HSC045-056', 'LUTBEHBMNTRI250', 'HASH BROWN MINI 4 X 2.5 KG', 'Lutosa Mini Triangle HAshbrown 2.5kg'),
(516, '7/7 THINCUT SHOESTRING 24x400g', 'RPSLUT070740024', 'Lutosa Shoes Strings 400', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:08:17', 'HSC045-058', 'RPSLUT070740024', '7/7 THINCUT SHOESTRING 24x400g', 'Lutosa Shoes Strings 400'),
(517, 'CLASSIC CUT FRENCH FRIES 20x450g', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, NULL, NULL, 'CLASSIC CUT FRENCH FRIES 20x450g', NULL),
(518, 'FROZEN STRAWBERRY', 'IQFSTRW0500', 'Frozen Strawberry 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 11:17:52', 'HSC045-060', 'IQFSTRW0500', 'FROZEN STRAWBERRY', 'Frozen Strawberry 500 grams'),
(519, 'BEEF BALL W/ MOZZA 300g', 'CB0120300G', 'Beef ball with Cheese 300 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:59:37', 'HSC045-061', 'CB0120300G', 'BEEF BALL W/ MOZZA 300g', 'Beef ball with Cheese 300 grams'),
(520, 'PRAWN FLAVOURED BALL', 'CB0070190G', 'Prawn Flavor Ball with Fish roe 190 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:38:13', 'HSC045-062', 'CB0070190G', 'PRAWN FLAVOURED BALL', 'Prawn Flavor Ball with Fish roe 190 grams'),
(521, 'JUMBO FISH BEAN CURD 350g', 'CB010350', 'CB Jumbo Fish Bean Curd 350 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:47:03', 'HSC045-063', 'CB010350', 'JUMBO FISH BEAN CURD 350g', 'CB Jumbo Fish Bean Curd 350 grams'),
(522, 'REUNION COMBO W/ BROWN SAUCE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-064', NULL, 'REUNION COMBO W/ BROWN SAUCE', NULL),
(523, 'MINI COMBO W/ GOLDEN SAUCE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-065', NULL, 'MINI COMBO W/ GOLDEN SAUCE', NULL),
(524, 'CHRISTMAS BUNDLE 066', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-066', NULL, 'CHRISTMAS BUNDLE 066', NULL),
(525, 'BLUEBERRY 20 X 500G', 'IQFBLUE050020', 'Yummy Blueberries 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:59:16', 'HSC045-067', 'IQFBLUE050020', 'BLUEBERRY 20 X 500G', 'Yummy Blueberries 500 grams'),
(526, 'SPINACH BALL 20 X 500G', 'IQFSPIBLL050020', 'Yummy Spinach Balls 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:26:17', 'HSC045-068', 'IQFSPIBLL050020', 'SPINACH BALL 20 X 500G', 'Yummy Spinach Balls 500 grams'),
(527, 'ROSTIS WITH ONION TASTE 1 KG', 'RPLUTROS10010', 'Lutosa ROSTI 1 KG', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:36:29', 'HSC045-069', 'RPLUTROS10010', 'ROSTIS WITH ONION TASTE 1 KG', 'Lutosa ROSTI 1 KG'),
(528, 'RUSTIC POTATO SLICES 2.5KG', 'LUTBESLRUS25004', 'Lutosa Rustic Slices 2.5 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:35:06', 'HSC045-70', 'LUTBESLRUS25004', 'RUSTIC POTATO SLICES 2.5KG', 'Lutosa Rustic Slices 2.5 kg'),
(529, 'KOREAN STYLE FISHCAKE', 'CBFCKR0320', 'CB korean Style Fish Cake 320 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:46:19', 'HSC045-071', 'CBFCKR0320', 'KOREAN STYLE FISHCAKE', 'CB korean Style Fish Cake 320 grams'),
(530, 'FUZHOU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-072', NULL, 'FUZHOU', NULL),
(531, 'FISHBALL WITH SALTED EGG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-073', NULL, 'FISHBALL WITH SALTED EGG', NULL),
(532, 'PARTY COMBO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', NULL, 'HSC045-074', NULL, 'PARTY COMBO', NULL),
(533, '7/7 SHOESTRING 1 KILO NEW PACK', 'LUTCN77ORG10010', 'Lutosa Red Pack 1 x 10 New packaging', NULL, NULL, NULL, 10.000, NULL, 1, '2026-10-16 08:19:02', '2026-10-17 08:50:48', 'HSC045-075', 'LUTCN77ORG10010', '7/7 SHOESTRING 1 KILO NEW PACK', 'Lutosa Red Pack 1 x 10 New packaging'),
(534, 'POTATO FLAKES 10X1KG', 'LUBETFLK01006', 'Lutosa Potato Flakes 5 mm 1 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:41:19', 'HSC045-076', 'LUBETFLK01006', 'POTATO FLAKES 10X1KG', 'Lutosa Potato Flakes 5 mm 1 kg'),
(535, 'NATURAL CUT ONION RING', 'BSQORBR0500', 'Onion Ring Natural Cut (Beer flavor)', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:42:34', 'HSC045-077', 'BSQORBR0500', 'NATURAL CUT ONION RING', 'Onion Ring Natural Cut (Beer flavor)'),
(536, 'BREADED JALAPENO WITH CHEESE', 'BSQJAL0500', 'Baby Star Jalapeno Stick 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:57:50', 'HSC045-078', 'BSQJAL0500', 'BREADED JALAPENO WITH CHEESE', 'Baby Star Jalapeno Stick 500 grams'),
(537, 'BATTERED ONION RING', 'BSQORBAT0500', 'Onion Ring Battered Formed 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:59:51', 'HSC045-079', 'BSQORBAT0500', 'BATTERED ONION RING', 'Onion Ring Battered Formed 500 grams'),
(538, 'BREADER MOZZARELLA CHEESE', 'BSQMOZ0500', 'Baby Star Mozarella Stick 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:57:38', 'HSC045-080', 'BSQMOZ0500', 'BREADER MOZZARELLA CHEESE', 'Baby Star Mozarella Stick 500 grams'),
(539, 'SQUID INK CALAMARI RING', 'BSQCALSI0500', 'Baby Star Squid IIn Calamari Ring 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:25:02', 'HSC045-081', 'BSQCALSI0500', 'SQUID INK CALAMARI RING', 'Baby Star Squid IIn Calamari Ring 500 grams'),
(540, '13/13 STRAIGHTCUT', 'LUTCN13132006', 'Lutosa 13/13 2 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:43:04', 'HSC045-082', 'LUTCN13132006', '13/13 STRAIGHTCUT', 'Lutosa 13/13 2 kg'),
(541, 'CHICKEN POPPIN\' BITES 500G', 'BTSPOP0500', 'Best tasting Snacks Chicken Poppers 500 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:55:31', 'HSC045-083', 'BTSPOP0500', 'CHICKEN POPPIN\' BITES 500G', 'Best tasting Snacks Chicken Poppers 500 grams'),
(542, 'CHICKEN BREAST CHUNKS 1KG', 'BTSCCHK1000', 'BTS Coated Chicken Breast Chunk 1kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:09:10', 'HSC045-084', 'BTSCCHK1000', 'CHICKEN BREAST CHUNKS 1KG', 'BTS Coated Chicken Breast Chunk 1kg'),
(543, 'SHREDDED CHICKEN 1KG', 'BTSSHC01000', 'BTS Shredded Chicken Breast 1 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:30:25', 'HSC045-085', 'BTSSHC01000', 'SHREDDED CHICKEN 1KG', 'BTS Shredded Chicken Breast 1 kg'),
(544, 'MIXED VEGGIES 10X1KG', 'IQFMIX33401000', 'Mixed Vegetables Corn, carrots & peas 334  1Kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:44:25', 'HSC045-086', 'IQFMIX33401000', 'MIXED VEGGIES 10X1KG', 'Mixed Vegetables Corn, carrots & peas 334  1Kg'),
(545, '12/12 CRINKLE CUT CHINA 10X1KG', 'LUTCNCKL10010', 'Lutosa Crinkle Cut 1kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:42:07', 'HSC045-087', 'LUTCNCKL10010', '12/12 CRINKLE CUT CHINA 10X1KG', 'Lutosa Crinkle Cut 1kg'),
(546, 'CHICKEN SHREDDED 250G X 40', 'BTSSHC00250', 'BTS Shredded Chicken Breast 250 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:55:19', 'HSC045-088', 'BTSSHC00250', 'CHICKEN SHREDDED 250G X 40', 'BTS Shredded Chicken Breast 250 grams'),
(547, 'CHICKEN CHUNKS 250G X 40', 'BTSCCHK0250', 'BTS Coated Chicken Breast Chunk 250 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:56:04', 'HSC045-089', 'BTSCCHK0250', 'CHICKEN CHUNKS 250G X 40', 'BTS Coated Chicken Breast Chunk 250 grams'),
(548, 'CHICKEN POPPIN\' BITES 200G X 25', 'BTSPOP0200', 'Best tasting Snacks Chicken Poppers 200 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:55:46', 'HSC045-090', 'BTSPOP0200', 'CHICKEN POPPIN\' BITES 200G X 25', 'Best tasting Snacks Chicken Poppers 200 grams'),
(549, 'CLASSIC FRIED CHICKEN 600G X 16', 'BTSBIC006', 'BTS Classic Crispy Chicken 6\'s', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:53:58', 'HSC045-091', 'BTSBIC006', 'CLASSIC FRIED CHICKEN 600G X 16', 'BTS Classic Crispy Chicken 6\'s'),
(550, 'GRILLED TENDER CHUNKS 200GX25', 'BTSGTC0200G', 'BTS Grill Tender Chunks 200 grams', NULL, NULL, NULL, 25.000, NULL, 1, '2026-10-16 08:19:02', '2026-10-17 08:51:03', 'HSC045-092', 'BTSGTC0200G', 'GRILLED TENDER CHUNKS 200GX25', 'BTS Grill Tender Chunks 200 grams'),
(551, '7/7 CRISPY COATED 6X2KG', 'LUTCNCT070720006', 'Lutosa Coated Fries 7/7 Shoestring 2 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:50:19', 'HSC045-093', 'LUTCNCT070720006', '7/7 CRISPY COATED 6X2KG', 'Lutosa Coated Fries 7/7 Shoestring 2 kg'),
(552, '10/10 CRISPY COATED 6X2KG', 'LUTCNCT101020006', 'Lutosa  Coated Fries 10/10 straight cut  2 kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 08:40:14', 'HSC045-094', 'LUTCNCT101020006', '10/10 CRISPY COATED 6X2KG', 'Lutosa  Coated Fries 10/10 straight cut  2 kg'),
(553, 'GC GARLICKY ADOBO 200GX40', 'GCGAR20040', 'Grill Choice Garlicky Adobo Chicken 200 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 11:15:23', 'HSC045-095', 'GCGAR20040', 'GC GARLICKY ADOBO 200GX40', 'Grill Choice Garlicky Adobo Chicken 200 grams'),
(554, 'GC HERB SALAD 100GX50', 'GCHTOM10050', 'Grill Choice Herb Salad (Tom Kha) 100 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:52:31', 'HSC045-096', 'GCHTOM10050', 'GC HERB SALAD 100GX50', 'Grill Choice Herb Salad (Tom Kha) 100 grams'),
(555, 'GC HERITAGE CHICKEN 200X40', 'GCHERBBQ20040', 'Grill Choice Heritage Barbeque Chicken 200 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:52:15', 'HSC045-097', 'GCHERBBQ20040', 'GC HERITAGE CHICKEN 200X40', 'Grill Choice Heritage Barbeque Chicken 200 grams'),
(556, 'GC PANDAN CHICKEN 240GX40', 'GCPAN24040', 'Grill Choice Pandan Chicken 240grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:51:57', 'HSC045-098', 'GCPAN24040', 'GC PANDAN CHICKEN 240GX40', 'Grill Choice Pandan Chicken 240grams'),
(557, 'GC PAPER WRAPPED CHICKEN 240GX40', 'GCPAP24040', 'Grill Choice Paper Wrapped Chicken 240grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:51:38', 'HSC045-099', 'GCPAP24040', 'GC PAPER WRAPPED CHICKEN 240GX40', 'Grill Choice Paper Wrapped Chicken 240grams'),
(558, 'GC HAINANESE 190g x48', 'GCHAI19048', 'Grill Choice Singapore Hainanese Chicken 190 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:52:46', 'HSC045-0100', 'GCHAI19048', 'GC HAINANESE 190g x48', 'Grill Choice Singapore Hainanese Chicken 190 grams'),
(559, 'BTS BUFFALO MIDDLE WINGS 24X300G', 'BTSMIDBUF30024', 'Best Tasting Snacks Buffalo MIddle Wings 300grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:57:24', 'HSC045-0101', 'BTSMIDBUF30024', 'BTS BUFFALO MIDDLE WINGS 24X300G', 'Best Tasting Snacks Buffalo MIddle Wings 300grams'),
(560, 'BTS NEW ORLEANS MIDDLE WING 24X300G', 'BTSMIDNO30024', 'Best Tasting Snack New Orleans MIddle wings 300 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:56:56', 'HSC045-0102', 'BTSMIDNO30024', 'BTS NEW ORLEANS MIDDLE WING 24X300G', 'Best Tasting Snack New Orleans MIddle wings 300 grams'),
(561, 'GC GRILLED BBQ MD 300GX24', 'GCMIDSBBQ30024', 'Grill Choice Smokey BBQ Middle Wing 300 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:53:06', 'HSC045-0103', 'GCMIDSBBQ30024', 'GC GRILLED BBQ MD 300GX24', 'Grill Choice Smokey BBQ Middle Wing 300 grams'),
(562, 'GC GARLICKY ADOBO MD 300G X 24', 'GCMIDGA30024', 'Grill Choice Garlicky Adobo Middle Wing 300 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 11:14:41', 'HSC045-0104', 'GCMIDGA30024', 'GC GARLICKY ADOBO MD 300G X 24', 'Grill Choice Garlicky Adobo Middle Wing 300 grams'),
(563, 'BTS CRISPY CHICKEN SKIN 24X300G', 'BTSSK30025', 'Best Tasting Snacks Crispy Chicken Skin 300 grams', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:57:12', 'HSC045-0105', 'BTSSK30025', 'BTS CRISPY CHICKEN SKIN 24X300G', 'Best Tasting Snacks Crispy Chicken Skin 300 grams'),
(564, 'MIXED VEGGIES 2WAY', 'IQFMIX21101000', 'Mixed Vegetables Corn & carrots 1:1 1kg', NULL, NULL, NULL, NULL, NULL, 1, '2026-10-16 08:19:02', '2026-10-16 09:43:46', 'HSC045-0106', 'IQFMIX21101000', 'MIXED VEGGIES 2WAY', 'Mixed Vegetables Corn & carrots 1:1 1kg');

-- --------------------------------------------------------

--
-- Table structure for table `product_mapping_import_stage`
--

CREATE TABLE `product_mapping_import_stage` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `qb_code` varchar(100) NOT NULL,
  `qb_description` varchar(255) NOT NULL,
  `ht_description` varchar(255) DEFAULT NULL,
  `ht_code` varchar(100) DEFAULT NULL,
  `source_line` int(10) UNSIGNED DEFAULT NULL,
  `mapping_verified` tinyint(1) NOT NULL DEFAULT 0,
  `review_note` varchar(255) DEFAULT NULL,
  `imported_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_mapping_import_stage`
--

INSERT INTO `product_mapping_import_stage` (`id`, `qb_code`, `qb_description`, `ht_description`, `ht_code`, `source_line`, `mapping_verified`, `review_note`, `imported_at`) VALUES
(1, 'BSQCALSI0500', 'Baby Star Squid IIn Calamari Ring 500 grams', '7/7 SHOESTRING 1 KILO', 'HSC045-0001', 3, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(2, 'BSQJAL0500', 'Baby Star Jalapeno Stick 500 grams', 'POTATO NOISETTES', 'HSC045-003', 4, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(3, 'BSQMOZ0500', 'Baby Star Mozarella Stick 500 grams', '10/10 FS CAJUN', 'HSC045-004', 5, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(4, 'BSQORBAT0500', 'Onion Ring Battered Formed 500 grams', '10/10 STRAIGHTCUT XTRA CRISPY', 'HSC045-009', 6, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(5, 'BSQORBR0500', 'Onion Ring Natural Cut (Beer flavor)', '7/7 FINEST SHOESTRING XTRA CRISPY', 'HSC045-010', 7, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(6, 'BTSBIC006', 'BTS Classic Crispy Chicken 6\'s', '10/10 STRAIGHTCUT SKIN-ON', 'HSC045-012', 8, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(7, 'BTSBIC012', 'BTS Classic Crispy Chicken 12\'s', '14/14 THICK CUT FRIES', 'HSC045-013', 9, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(8, 'BTSCCHK0250', 'BTS Coated Chicken Breast Chunk 250 grams', '5/5 SKINNY SKIN-ON', 'HSC045-015', 10, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(9, 'BTSCCHK1000', 'BTS Coated Chicken Breast Chunk 1kg', 'CRUNCHY HASH BROWN', 'HSC045-018', 11, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(10, 'BTSGTC0200G', 'BTS Grill Tender Chunks 200 grams', 'CRUNCHY OVAL HASH BROWN', 'HSC045-019', 12, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(11, 'BTSMIDBUF30024', 'Best Tasting Snacks Buffalo MIddle Wings 300grams', 'MASHED POTATO', 'HSC045-020', 13, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(12, 'BTSMIDNO30024', 'Best Tasting Snack New Orleans MIddle wings 300 grams', 'SPICY WEDGES', 'HSC045-022', 14, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(13, 'BTSPOP0200', 'Best tasting Snacks Chicken Poppers 200 grams', 'POTATO WEDGES', 'HSC045-023', 15, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(14, 'BTSPOP0500', 'Best tasting Snacks Chicken Poppers 500 grams', 'CRINKLE CUT', 'HSC045-025', 16, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(15, 'BTSSHC00250', 'BTS Shredded Chicken Breast 250 grams', 'FROZEN KERNEL CORN', 'HSC045-026', 17, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(16, 'BTSSHC01000', 'BTS Shredded Chicken Breast 1 kg', '7/7 THIN CUT SHOESTRING', 'HSC045-027', 18, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(17, 'BTSSK30025', 'Best Tasting Snacks Crispy Chicken Skin 300 grams', '7/7 SHOESTRING 2 KILO CHINA', 'HSC045-028', 19, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(18, 'CB0010190G', 'CB Sea Urchin Falvored Balls 190 grams', 'SAMPLE ITEM', 'HSC045-029', 20, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(19, 'CB0040160G', 'Japanese Fish Tofu 160 grams', 'KDHY 7/7 SHOESTRING 2KG', 'HSC045-030', 21, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(20, 'CB0050160G', 'Cuttlefish Ball with Squid Ink 160 grams', 'POTATO CRUNCHIES', 'HSC045-031', 22, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(21, 'CB0070190G', 'Prawn Flavor Ball with Fish roe 190 grams', 'SPICY WEDGES 750G', 'HSC045-032', 23, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(22, 'CB0080175G', 'Salmon Ball falvored with Cheese 175 grams', 'SEA URCHIN 190G X 40', 'HSC045-034', 24, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(23, 'CB0100500G', 'Fried Fish Ball 500 grams', 'SALMON FLAVOURED 175G X 40', 'HSC045-035', 25, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(24, 'CB010350', 'CB Jumbo Fish Bean Curd 350 grams', 'WHITE FISHBALL 500gx24', 'HSC045-036', 26, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(25, 'CB011COMBO', 'Lucky Combo 5 in 1', 'LUCKY COMBO 5IN1 500gx24', 'HSC045-037', 27, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(26, 'CB0120300G', 'Beef ball with Cheese 300 grams', 'FRIED FISH BALL 500gx24', 'HSC045-038', 28, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(27, 'CBBUDD0350', 'CB Buddha Soup 350 grams', 'JAPANESE FISH TOFU 160gx40', 'HSC045-039', 29, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(28, 'CBFBFUZ0300', 'CB Fishball Fuzhou Style 300 grams', 'CUTTLE FISH BALL W/ SQUID INK 1KGX10', 'HSC045-040', 30, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(29, 'CBFBSALT030040', 'CB Fishball with Salted Eggs 300 grams', 'CUTTLE FISH BALL W/ SQUID INK 160GX40', 'HSC045-041', 31, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(30, 'CBFCKR0320', 'CB korean Style Fish Cake 320 grams', '7/7 FINEST SHOESTRING 1034137-71', '1034137-71', 32, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(31, 'CBPARTY0300', 'CB Party Pack 300 grams', '7/7 THINCUT SHOESTRING RUSSET', 'HSC045-043', 33, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(32, 'CMDCK100', 'Starmax Frozen Kernel Corn 1 kg', '10/18 STEAK FRIES 2.5KG', 'HSC045-042', 34, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(33, 'crates', 'Crates', 'KRISSPY CRINKLE CUT 1KG', 'HSC045-044', 35, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(34, 'GCGAR20040', 'Grill Choice Garlicky Adobo Chicken 200 grams', '10/10 CLASSIC CUT FRIES 1KG', 'HSC045-45', 36, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(35, 'GCHAI19048', 'Grill Choice Singapore Hainanese Chicken 190 grams', '10/10 CLASSIC CUT FRIES 2.5KG', 'HSC045-046', 37, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(36, 'GCHERBBQ20040', 'Grill Choice Heritage Barbeque Chicken 200 grams', 'SAVEMORE 1KG', 'HSC045-047', 38, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(37, 'GCHTOM10050', 'Grill Choice Herb Salad (Tom Kha) 100 grams', 'SAVEMORE 2KG', 'HSC045-048', 39, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(38, 'GCMIDGA30024', 'Grill Choice Garlicky Adobo Middle Wing 300 grams', 'MIXED VEGGIES 20x500g', 'HSC045-049', 40, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(39, 'GCMIDSBBQ30024', 'Grill Choice Smokey BBQ Middle Wing 300 grams', 'CALIFORNIA MIXED', 'HSC045-050', 41, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(40, 'GCPAN24040', 'Grill Choice Pandan Chicken 240grams', 'MIXED BERRIES', 'HSC045-051', 42, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(41, 'GCPAP24040', 'Grill Choice Paper Wrapped Chicken 240grams', 'SWEET POTATO', 'HSC045-052', 43, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(42, 'IQFBLUE050020', 'Yummy Blueberries 500 grams', '10/10 STRAIGHTCUT 2KG CHINA', 'HSC045-053', 44, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(43, 'IQFCALI050020', 'Yummy California Mix 500 grams', 'POTATO NOISETTES 750G', 'HSC045-054', 45, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(44, 'IQFMBRS0500', 'Mixed Berries 500 grams', 'POTATO CROQUETTES 750G', 'HSC045-055', 46, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(45, 'IQFMIX21101000', 'Mixed Vegetables Corn & carrots 1:1 1kg', 'HASH BROWN MINI 4 X 2.5 KG', 'HSC045-056', 47, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(46, 'IQFMIX33401000', 'Mixed Vegetables Corn, carrots & peas 334 1Kg', '7/7 THINCUT SHOESTRING 24x400g', 'HSC045-058', 48, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(47, 'IQFMIX3340500', 'Mixed Vegetables Corn, carrots & peas 334 500 grams', 'CLASSIC CUT FRENCH FRIES 20x450g', NULL, 49, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(48, 'IQFSPIBLL050020', 'Yummy Spinach Balls 500 grams', 'FROZEN STRAWBERRY', 'HSC045-060', 50, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(49, 'IQFSTRW0500', 'Frozen Strawberry 500 grams', 'BEEF BALL W/ MOZZA 300g', 'HSC045-061', 51, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(50, 'ISYUM106040', 'Yummy Fish Cracker Original 60 grams x 40 packs', 'PRAWN FLAVOURED BALL', 'HSC045-062', 52, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(51, 'ISYUM112012', 'Yummy Fish cracker Original 200 grams', 'JUMBO FISH BEAN CURD 350g', 'HSC045-063', 53, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(52, 'KDHY0707200', 'KDHY 7/7 Shoe strings 2 kg', 'REUNION COMBO W/ BROWN SAUCE', 'HSC045-064', 54, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(53, 'LUBETFLK01006', 'Lutosa Potato Flakes 5 mm 1 kg', 'MINI COMBO W/ GOLDEN SAUCE', 'HSC045-065', 55, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(54, 'LUTBE0505FS02504', 'Lutosa Skinny Fries Xtra Crispy Food services 2.5kg', 'CHRISTMAS BUNDLE 066', 'HSC045-066', 56, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(55, 'LUTBE1010SO02504', 'Lutosa Finest 10/10 Straight Cut Skin on 2.5 kg', 'BLUEBERRY 20 X 500G', 'HSC045-067', 57, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(56, 'LUTBE10182504', 'Lutosa Steak Fries 10-18 2.5 x 4', 'SPINACH BALL 20 X 500G', 'HSC045-068', 58, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(57, 'LUTBE1414SO02504', 'Lutosa Finest 14/14 Straight Cut Skin On 2.5kg', 'ROSTIS WITH ONION TASTE 1 KG', 'HSC045-069', 59, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(58, 'LUTBECRKL2504', 'Lutosa Crinkle Cut 2.5 x 4', 'RUSTIC POTATO SLICES 2.5KG', 'HSC045-70', 60, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(59, 'LUTBEFX1010FX0206', 'Lutosa Finest 10/10 Xtra Xrispy 2kg', 'KOREAN STYLE FISHCAKE', 'HSC045-071', 61, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(60, 'LUTBEHBOV20006', 'Lutosa Hash Brown Oval 2kg', 'FUZHOU', 'HSC045-072', 62, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(61, 'LUTBEHBTRI250', 'Lutosa Hashbrown Traingle 2.5kg', 'FISHBALL WITH SALTED EGG', 'HSC045-073', 63, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(62, 'LUTBEMASH250', 'Lutosa Mash Potato 2.5 kg', 'PARTY COMBO', 'HSC045-074', 64, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(63, 'LUTBENOIS0254', 'Lutosa Potato Noisettes 2.5kg', '7/7 SHOESTRING 1 KILO NEW PACK', 'HSC045-075', 65, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(64, 'LUTBESLRUS25004', 'Lutosa Rustic Slices 2.5 kg', 'POTATO FLAKES 10X1KG', 'HSC045-076', 66, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(65, 'LUTBEWDGQTR2504', 'Lutosa Quarter Wedges 2.5 x 4', 'NATURAL CUT ONION RING', 'HSC045-077', 67, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(66, 'LUTBEWDGTEX2504', 'Lutosa Tex Mex Wedges 2.5 x 4', 'BREADED JALAPENO WITH CHEESE', 'HSC045-078', 68, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(67, 'LUTCN1010ST20006', 'Lutosa CN 10/10 Stright Cut 2 kg', 'BATTERED ONION RING', 'HSC045-079', 69, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(68, 'LUTCN13132006', 'Lutosa 13/13 2 kg', 'BREADER MOZZARELLA CHEESE', 'HSC045-080', 70, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(69, 'LUTCN7720006', 'Lutosa Orange Pack 2 kg', 'SQUID INK CALAMARI RING', 'HSC045-081', 71, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(70, 'LUTCN77ORG10010', 'Lutosa Red Pack 1 x 10 New packaging', '13/13 STRAIGHTCUT', 'HSC045-082', 72, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(71, 'LUTCN77ORG100B', 'Lutosa Orange Pack 1 x 10 old crop', 'CHICKEN POPPIN\' BITES 500G', 'HSC045-083', 73, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(72, 'LUTCNCKL10010', 'Lutosa Crinkle Cut 1kg', 'CHICKEN BREAST CHUNKS 1KG', 'HSC045-084', 74, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(73, 'LUTCNCT070720006', 'Lutosa Coated Fries 7/7 Shoestring 2 kg', 'SHREDDED CHICKEN 1KG', 'HSC045-085', 75, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(74, 'LUTCNCT101020006', 'Lutosa Coated Fries 10/10 straight cut 2 kg', 'MIXED VEGGIES 10X1KG', 'HSC045-086', 76, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(75, 'LUTCNSP10102504', 'Lutosa Sweet Potato 2.5 kg', '12/12 CRINKLE CUT CHINA 10X1KG', 'HSC045-087', 77, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(76, 'RPLUT0707100', 'Lutosa Red Pack 1 x 10', 'CHICKEN SHREDDED 250G X 40', 'HSC045-088', 78, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(77, 'RPLUT1010100', 'RP Lutosa Classic Cut 10/101kg', 'CHICKEN CHUNKS 250G X 40', 'HSC045-089', 79, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(78, 'RPLUTCRK100', 'Lutosa Crinkle Cut 1 x 10', 'CHICKEN POPPIN\' BITES 200G X 25', 'HSC045-090', 80, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(79, 'RPLUTCROQ75012', 'Lutosa Croquette 750 grams', 'CLASSIC FRIED CHICKEN 600G X 16', 'HSC045-091', 81, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(80, 'RPLUTCRU0750', 'Lutosa Crunchies 750grams', 'GRILLED TENDER CHUNKS 200GX25', 'HSC045-092', 82, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(81, 'RPLUTNOIS75012', 'Lutosa Noisettes 750 grams Retail Pack', '7/7 CRISPY COATED 6X2KG', 'HSC045-093', 83, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(82, 'RPLUTROS10010', 'Lutosa ROSTI 1 KG', '10/10 CRISPY COATED 6X2KG', 'HSC045-094', 84, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(83, 'RPLUTWDGTEX0750', 'Lutosa Spicy Wedges 750 grams', 'GC GARLICKY ADOBO 200GX40', 'HSC045-095', 85, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(84, 'RPSLUT070740024', 'Lutosa Shoes Strings 400', 'GC HERB SALAD 100GX50', 'HSC045-096', 86, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(85, 'RPSLUT101045020', 'RP Lutosa 10/10 450 grams', 'GC HERITAGE CHICKEN 200X40', 'HSC045-097', 87, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(86, 'SVCHN770110', 'Savemore 7/7 Fries 1 kg', 'GC PANDAN CHICKEN 240GX40', 'HSC045-098', 88, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(87, 'SVCHN770206', 'Savemore 7/7 Fries 2kg', 'GC PAPER WRAPPED CHICKEN 240GX40', 'HSC045-099', 89, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(88, 'TLSVCHN770110', 'Savemore 7/7 Fries 1 kg', 'GC HAINANESE 190g x48', 'HSC045-0100', 90, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(89, 'BTSChunks+Shred', 'BTS Chicken Chunks 1kg + free BTS Shredded Chicken 250 grams', 'BTS BUFFALO MIDDLE WINGS 24X300G', 'HSC045-0101', 91, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(90, 'BTSShred+chunks', 'BTS Shredded Chicken 1 kg + free BTS Chunks 250 grams', 'BTS NEW ORLEANS MIDDLE WING 24X300G', 'HSC045-0102', 92, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(91, 'XMAS300A', 'Christmas Bundle 300A Fries; corn, california mix', 'GC GRILLED BBQ MD 300GX24', 'HSC045-0103', 93, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(92, 'XMAS300B', 'Christmas Bundle 300 fries , corn , mix veggie', 'GC GARLICKY ADOBO MD 300G X 24', 'HSC045-0104', 94, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(93, 'XMAS369A', 'Christmas Bundle 369A Corn, california mix, white fish ball', 'BTS CRISPY CHICKEN SKIN 24X300G', 'HSC045-0105', 95, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(94, 'XMAS369B', 'Christmas Basket 369B corn, california mix, fried fish ball', 'MIXED VEGGIES 2WAY', 'HSC045-0106', 96, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(95, 'XMAS369C', 'Christmas Bundle 369C Corn , California MIx, Japanese Tofu', NULL, NULL, 97, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(96, 'XMAS749', 'Christmas Bundle 749', NULL, NULL, 98, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(97, 'XMAS899', 'Christmas Basket 899', NULL, NULL, 99, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(98, 'XMAS899B', 'Christmas Basket 899 b', NULL, NULL, 100, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24'),
(99, 'XMAS999', 'Christmas Bundle 999', NULL, NULL, 101, 0, 'Verify QB and HT descriptions identify the same product before promoting to live product master.', '2026-10-15 14:43:24');

-- --------------------------------------------------------

--
-- Table structure for table `qbwc_readonly_jobs`
--

CREATE TABLE `qbwc_readonly_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `session_id` bigint(20) UNSIGNED DEFAULT NULL,
  `request_type` enum('CustomerQuery','ItemQuery') NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `request_xml` mediumtext NOT NULL,
  `status` enum('queued','in_flight','retry','completed','failed') NOT NULL DEFAULT 'queued',
  `attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `response_code` varchar(20) NOT NULL DEFAULT '',
  `response_hash` char(64) DEFAULT NULL,
  `diagnostic` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `qbwc_requests`
--

CREATE TABLE `qbwc_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `request_type` enum('CustomerQuery','ItemQuery','Other') NOT NULL DEFAULT 'Other',
  `request_xml` mediumtext DEFAULT NULL,
  `response_xml` mediumtext DEFAULT NULL,
  `status` enum('pending','received','failed','stale','expired') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `qbwc_sessions`
--

CREATE TABLE `qbwc_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket` varchar(64) NOT NULL,
  `username` varchar(80) NOT NULL,
  `status` enum('active','closed','failed','expired') NOT NULL DEFAULT 'active',
  `authenticated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime NOT NULL,
  `last_error` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `qb_jobs`
--

CREATE TABLE `qb_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invoice_id` bigint(20) UNSIGNED NOT NULL,
  `request_key` char(36) NOT NULL,
  `status` enum('Queued','Processing','Invoiced','Error','Uncertain Result') NOT NULL DEFAULT 'Queued',
  `request_xml` mediumtext DEFAULT NULL,
  `response_xml` mediumtext DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `qb_invoice_no` varchar(100) DEFAULT NULL,
  `qb_txn_id` varchar(100) DEFAULT NULL,
  `attempts` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sales_orders`
--

CREATE TABLE `sales_orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `withdrawal_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `qb_customer_list_id` varchar(100) DEFAULT NULL,
  `so_number` varchar(100) DEFAULT NULL,
  `sales_order_date` date NOT NULL,
  `po_no` varchar(100) DEFAULT NULL,
  `memo` text DEFAULT NULL,
  `status` enum('Draft') NOT NULL DEFAULT 'Draft',
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sales_orders`
--

INSERT INTO `sales_orders` (`id`, `withdrawal_id`, `customer_id`, `qb_customer_list_id`, `so_number`, `sales_order_date`, `po_no`, `memo`, `status`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(3, 15, 656, NULL, '2775', '2026-10-21', 'ATP CAVITE', 'ATP CAVITE', 'Draft', 1, 1, '2026-10-21 08:45:09', '2026-10-21 08:48:13'),
(4, 16, 656, NULL, NULL, '2026-10-21', NULL, NULL, 'Draft', 1, 1, '2026-10-21 10:02:13', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sales_order_items`
--

CREATE TABLE `sales_order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sales_order_id` bigint(20) UNSIGNED NOT NULL,
  `line_no` smallint(5) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `item_name` varchar(255) NOT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `qb_item_list_id` varchar(100) DEFAULT NULL,
  `site_id` bigint(20) UNSIGNED DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `ordered_quantity` bigint(20) UNSIGNED NOT NULL,
  `lot_number` varchar(100) DEFAULT NULL,
  `u_m` varchar(40) DEFAULT NULL,
  `rate` decimal(12,2) DEFAULT NULL,
  `class_name` varchar(100) DEFAULT NULL,
  `amount` decimal(14,2) NOT NULL,
  `line_status` varchar(40) DEFAULT NULL,
  `fulfilled_quantity` bigint(20) UNSIGNED DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `tax_code` varchar(40) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sales_order_items`
--

INSERT INTO `sales_order_items` (`id`, `sales_order_id`, `line_no`, `product_id`, `item_name`, `item_code`, `qb_item_list_id`, `site_id`, `description`, `ordered_quantity`, `lot_number`, `u_m`, `rate`, `class_name`, `amount`, `line_status`, `fulfilled_quantity`, `expiration_date`, `tax_code`, `created_at`, `updated_at`) VALUES
(6, 3, 1, 533, '7/7 SHOESTRING 1 KILO NEW PACK', 'LUTCN77ORG10010', NULL, 2, 'Lutosa Red Pack 1 x 10 New packaging', 10, NULL, NULL, 99.00, NULL, 990.00, NULL, NULL, NULL, NULL, '2026-10-21 09:46:44', NULL),
(7, 4, 1, 533, '7/7 SHOESTRING 1 KILO NEW PACK', 'LUTCN77ORG10010', NULL, NULL, 'Lutosa Red Pack 1 x 10 New packaging', 10, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-10-21 10:02:13', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sites`
--

CREATE TABLE `sites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `site_name` varchar(120) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sites`
--

INSERT INTO `sites` (`id`, `site_name`, `active`) VALUES
(1, 'Drop Ship', 1),
(2, 'High Tower Cold Storage', 1),
(3, 'Columbia Fruit Traders', 1),
(4, 'Met Food Office', 1),
(5, 'Polar Bear Freezing & Storage C', 0),
(6, 'QC Warehouse', 0),
(7, 'Toplis Logistics Inc', 0);

-- --------------------------------------------------------

--
-- Table structure for table `withdrawals`
--

CREATE TABLE `withdrawals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `withdrawal_no` varchar(40) NOT NULL,
  `saved_on` datetime NOT NULL DEFAULT current_timestamp(),
  `time_received` time DEFAULT NULL,
  `pick_up_time` time DEFAULT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `form_date` date NOT NULL,
  `po_no` varchar(100) DEFAULT NULL,
  `internal_note` text DEFAULT NULL,
  `status` enum('Draft','Ready for Invoicing','Invoice Preparation','Invoiced','Cancelled') NOT NULL DEFAULT 'Draft',
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `withdrawals`
--

INSERT INTO `withdrawals` (`id`, `withdrawal_no`, `saved_on`, `time_received`, `pick_up_time`, `client_id`, `form_date`, `po_no`, `internal_note`, `status`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(15, '2026-101175', '2026-10-21 08:45:06', NULL, '04:00:00', 656, '2026-10-21', NULL, NULL, 'Ready for Invoicing', 1, 1, '2026-10-21 08:45:06', '2026-10-21 08:46:11'),
(16, '2026-101176', '2026-10-21 08:49:11', NULL, '04:00:00', 656, '2026-10-21', NULL, NULL, 'Invoice Preparation', 1, 1, '2026-10-21 08:49:11', '2026-10-21 08:49:19');

-- --------------------------------------------------------

--
-- Table structure for table `withdrawal_items`
--

CREATE TABLE `withdrawal_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `withdrawal_id` bigint(20) UNSIGNED NOT NULL,
  `line_no` smallint(5) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` bigint(20) UNSIGNED NOT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `ht_code` varchar(100) DEFAULT NULL,
  `ht_description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `withdrawal_items`
--

INSERT INTO `withdrawal_items` (`id`, `withdrawal_id`, `line_no`, `product_id`, `product_name`, `quantity`, `remarks`, `created_at`, `ht_code`, `ht_description`) VALUES
(36, 15, 1, 533, '7/7 SHOESTRING 1 KILO NEW PACK', 10, NULL, '2026-10-21 08:47:30', 'HSC045-075', '7/7 SHOESTRING 1 KILO NEW PACK'),
(37, 16, 1, 533, '7/7 SHOESTRING 1 KILO NEW PACK', 10, NULL, '2026-10-21 08:49:11', 'HSC045-075', '7/7 SHOESTRING 1 KILO NEW PACK');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_activity_created` (`created_at`),
  ADD KEY `fk_activity_employee` (`employee_id`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `client_name` (`client_name`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `employee_permissions`
--
ALTER TABLE `employee_permissions`
  ADD PRIMARY KEY (`employee_id`,`permission_code`),
  ADD KEY `fk_ep_granted_by` (`granted_by`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `withdrawal_id` (`withdrawal_id`),
  ADD UNIQUE KEY `uq_invoices_invoice_number` (`invoice_number`),
  ADD KEY `fk_invoice_customer` (`customer_id`),
  ADD KEY `fk_invoice_submitted` (`submitted_by`),
  ADD KEY `fk_invoice_created` (`created_by`),
  ADD KEY `fk_invoice_updated` (`updated_by`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_invoice_items_invoice` (`invoice_id`),
  ADD KEY `fk_ii_wi` (`withdrawal_item_id`),
  ADD KEY `fk_ii_created` (`created_by`),
  ADD KEY `fk_ii_updated` (`updated_by`),
  ADD KEY `fk_ii_product_restrict` (`product_id`),
  ADD KEY `fk_ii_site_restrict` (`site_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_name` (`product_name`),
  ADD UNIQUE KEY `uq_products_ht_code` (`ht_code`),
  ADD UNIQUE KEY `uq_products_qb_code` (`qb_code`),
  ADD KEY `fk_products_site` (`default_site_id`);

--
-- Indexes for table `product_mapping_import_stage`
--
ALTER TABLE `product_mapping_import_stage`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_product_mapping_stage_qb_code` (`qb_code`),
  ADD KEY `idx_product_mapping_stage_ht_code` (`ht_code`),
  ADD KEY `idx_product_mapping_stage_verified` (`mapping_verified`);

--
-- Indexes for table `qbwc_readonly_jobs`
--
ALTER TABLE `qbwc_readonly_jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_qbwc_readonly_jobs_claim` (`session_id`,`status`,`id`),
  ADD KEY `idx_qbwc_readonly_jobs_queue` (`status`,`session_id`,`id`),
  ADD KEY `idx_qbwc_readonly_jobs_response` (`session_id`,`response_hash`);

--
-- Indexes for table `qbwc_requests`
--
ALTER TABLE `qbwc_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_qbwc_requests_session` (`session_id`);

--
-- Indexes for table `qbwc_sessions`
--
ALTER TABLE `qbwc_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ticket` (`ticket`),
  ADD KEY `idx_qbwc_sessions_username` (`username`),
  ADD KEY `idx_qbwc_sessions_status` (`status`);

--
-- Indexes for table `qb_jobs`
--
ALTER TABLE `qb_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `request_key` (`request_key`),
  ADD UNIQUE KEY `uq_qb_job_invoice` (`invoice_id`),
  ADD KEY `fk_job_employee` (`created_by`);

--
-- Indexes for table `sales_orders`
--
ALTER TABLE `sales_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `withdrawal_id` (`withdrawal_id`),
  ADD UNIQUE KEY `uq_sales_orders_so_number` (`so_number`),
  ADD KEY `fk_sales_orders_customer` (`customer_id`),
  ADD KEY `fk_sales_orders_created` (`created_by`),
  ADD KEY `fk_sales_orders_updated` (`updated_by`);

--
-- Indexes for table `sales_order_items`
--
ALTER TABLE `sales_order_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_sales_order_line` (`sales_order_id`,`line_no`),
  ADD KEY `fk_soi_product_restrict` (`product_id`),
  ADD KEY `fk_soi_site_restrict` (`site_id`);

--
-- Indexes for table `sites`
--
ALTER TABLE `sites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_name` (`site_name`);

--
-- Indexes for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `withdrawal_no` (`withdrawal_no`),
  ADD KEY `idx_withdrawals_date` (`form_date`),
  ADD KEY `idx_withdrawals_status` (`status`),
  ADD KEY `fk_withdrawals_client` (`client_id`),
  ADD KEY `fk_withdrawals_created` (`created_by`),
  ADD KEY `fk_withdrawals_updated` (`updated_by`);

--
-- Indexes for table `withdrawal_items`
--
ALTER TABLE `withdrawal_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_withdrawal_line` (`withdrawal_id`,`line_no`),
  ADD KEY `idx_wi_product` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;

--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=820;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=565;

--
-- AUTO_INCREMENT for table `product_mapping_import_stage`
--
ALTER TABLE `product_mapping_import_stage`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT for table `qbwc_readonly_jobs`
--
ALTER TABLE `qbwc_readonly_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `qbwc_requests`
--
ALTER TABLE `qbwc_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `qbwc_sessions`
--
ALTER TABLE `qbwc_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `qb_jobs`
--
ALTER TABLE `qb_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales_orders`
--
ALTER TABLE `sales_orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `sales_order_items`
--
ALTER TABLE `sales_order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `sites`
--
ALTER TABLE `sites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `withdrawal_items`
--
ALTER TABLE `withdrawal_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `fk_activity_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `employee_permissions`
--
ALTER TABLE `employee_permissions`
  ADD CONSTRAINT `fk_ep_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ep_granted_by` FOREIGN KEY (`granted_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `fk_invoice_created` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_invoice_customer` FOREIGN KEY (`customer_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `fk_invoice_submitted` FOREIGN KEY (`submitted_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_invoice_updated` FOREIGN KEY (`updated_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_invoice_withdrawal` FOREIGN KEY (`withdrawal_id`) REFERENCES `withdrawals` (`id`);

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `fk_ii_created` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_ii_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ii_product_restrict` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `fk_ii_site_restrict` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`),
  ADD CONSTRAINT `fk_ii_updated` FOREIGN KEY (`updated_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_ii_wi` FOREIGN KEY (`withdrawal_item_id`) REFERENCES `withdrawal_items` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_site` FOREIGN KEY (`default_site_id`) REFERENCES `sites` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `qbwc_readonly_jobs`
--
ALTER TABLE `qbwc_readonly_jobs`
  ADD CONSTRAINT `fk_qbwc_readonly_jobs_session` FOREIGN KEY (`session_id`) REFERENCES `qbwc_sessions` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `qbwc_requests`
--
ALTER TABLE `qbwc_requests`
  ADD CONSTRAINT `fk_qbwc_requests_session` FOREIGN KEY (`session_id`) REFERENCES `qbwc_sessions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `qb_jobs`
--
ALTER TABLE `qb_jobs`
  ADD CONSTRAINT `fk_job_employee` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_job_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`);

--
-- Constraints for table `sales_orders`
--
ALTER TABLE `sales_orders`
  ADD CONSTRAINT `fk_sales_orders_created` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_sales_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `fk_sales_orders_updated` FOREIGN KEY (`updated_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_sales_orders_withdrawal` FOREIGN KEY (`withdrawal_id`) REFERENCES `withdrawals` (`id`);

--
-- Constraints for table `sales_order_items`
--
ALTER TABLE `sales_order_items`
  ADD CONSTRAINT `fk_soi_product_restrict` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `fk_soi_sales_order` FOREIGN KEY (`sales_order_id`) REFERENCES `sales_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_soi_site_restrict` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`);

--
-- Constraints for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD CONSTRAINT `fk_withdrawals_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `fk_withdrawals_created` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_withdrawals_updated` FOREIGN KEY (`updated_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `withdrawal_items`
--
ALTER TABLE `withdrawal_items`
  ADD CONSTRAINT `fk_wi_product_restrict` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `fk_wi_withdrawal` FOREIGN KEY (`withdrawal_id`) REFERENCES `withdrawals` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
