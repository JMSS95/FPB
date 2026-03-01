-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 01-Mar-2026 às 19:19
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `ok4_base`
--
CREATE DATABASE IF NOT EXISTS `ok4_base` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ok4_base`;

-- --------------------------------------------------------

--
-- Estrutura da tabela `categorias`
--

DROP TABLE IF EXISTS `categorias`;
CREATE TABLE IF NOT EXISTS `categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `categorias`
--

INSERT INTO `categorias` (`id`, `descricao`) VALUES
(1, 'Equipamento'),
(2, 'Bilhetes'),
(3, 'Roupa'),
(4, 'Formação');

-- --------------------------------------------------------

--
-- Estrutura da tabela `cidade`
--

DROP TABLE IF EXISTS `cidade`;
CREATE TABLE IF NOT EXISTS `cidade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) DEFAULT NULL,
  `id_distrito` int(11) DEFAULT NULL,
  `id_concelho` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cidade_id_distrito` (`id_distrito`),
  KEY `idx_cidade_id_concelho` (`id_concelho`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `cidade`
--

INSERT INTO `cidade` (`id`, `descricao`, `id_distrito`, `id_concelho`) VALUES
(1, 'Coimbra', NULL, NULL),
(2, 'Porto', NULL, NULL),
(3, 'Braga', NULL, NULL),
(4, 'Desconhecido', NULL, NULL),
(5, 'Aveiro', NULL, NULL),
(6, 'Lisboa', NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_concelhos`
--

DROP TABLE IF EXISTS `core_concelhos`;
CREATE TABLE IF NOT EXISTS `core_concelhos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cod` int(11) NOT NULL,
  `id_distrito` int(11) NOT NULL,
  `descricao` varchar(255) NOT NULL DEFAULT '',
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_core_concelhos_core_distritos` (`id_distrito`)
) ENGINE=InnoDB AUTO_INCREMENT=309 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_concelhos`
--

INSERT INTO `core_concelhos` (`id`, `cod`, `id_distrito`, `descricao`, `is_active`) VALUES
(1, 1, 1, 'Águeda', 1),
(2, 2, 1, 'Albergaria-A-Velha', 1),
(3, 3, 1, 'Anadia', 1),
(4, 4, 1, 'Arouca', 1),
(5, 5, 1, 'Aveiro', 1),
(6, 6, 1, 'Castelo De Paiva', 1),
(7, 7, 1, 'Espinho', 1),
(8, 8, 1, 'Estarreja', 1),
(9, 9, 1, 'Santa Maria Da Feira', 1),
(10, 10, 1, 'ílhavo', 1),
(11, 11, 1, 'Mealhada', 1),
(12, 12, 1, 'Murtosa', 1),
(13, 13, 1, 'Oliveira De Azeméis', 1),
(14, 14, 1, 'Oliveira Do Bairro', 1),
(15, 15, 1, 'Ovar', 1),
(16, 16, 1, 'São João Da Madeira', 1),
(17, 17, 1, 'Sever Do Vouga', 1),
(18, 18, 1, 'Vagos', 1),
(19, 19, 1, 'Vale De Cambra', 1),
(20, 1, 2, 'Aljustrel', 1),
(21, 2, 2, 'Almodôvar', 1),
(22, 3, 2, 'Alvito', 1),
(23, 4, 2, 'Barrancos', 1),
(24, 5, 2, 'Beja', 1),
(25, 6, 2, 'Castro Verde', 1),
(26, 7, 2, 'Cuba', 1),
(27, 8, 2, 'Ferreira Do Alentejo', 1),
(28, 9, 2, 'Mértola', 1),
(29, 10, 2, 'Moura', 1),
(30, 11, 2, 'Odemira', 1),
(31, 12, 2, 'Ourique', 1),
(32, 13, 2, 'Serpa', 1),
(33, 14, 2, 'Vidigueira', 1),
(34, 1, 3, 'Amares', 1),
(35, 2, 3, 'Barcelos', 1),
(36, 3, 3, 'Braga', 1),
(37, 4, 3, 'Cabeceiras De Basto', 1),
(38, 5, 3, 'Celorico De Basto', 1),
(39, 6, 3, 'Esposende', 1),
(40, 7, 3, 'Fafe', 1),
(41, 8, 3, 'Guimarãoes', 1),
(42, 9, 3, 'Póvoa De Lanhoso', 1),
(43, 10, 3, 'Terras De Bouro', 1),
(44, 11, 3, 'Vieira Do Minho', 1),
(45, 12, 3, 'Vila Nova De Famalicão', 1),
(46, 13, 3, 'Vila Verde', 1),
(47, 14, 3, 'Vizela', 1),
(48, 1, 4, 'Alfândega Da Fé', 1),
(49, 2, 4, 'Bragança', 1),
(50, 3, 4, 'Carrazeda De Ansiãoes', 1),
(51, 4, 4, 'Freixo De Espada í€ Cinta', 1),
(52, 5, 4, 'Macedo De Cavaleiros', 1),
(53, 6, 4, 'Miranda Do Douro', 1),
(54, 7, 4, 'Mirandela', 1),
(55, 8, 4, 'Mogadouro', 1),
(56, 9, 4, 'Torre De Moncorvo', 1),
(57, 10, 4, 'Vila Flor', 1),
(58, 11, 4, 'Vimioso', 1),
(59, 12, 4, 'Vinhais', 1),
(60, 1, 5, 'Belmonte', 1),
(61, 2, 5, 'Castelo Branco', 1),
(62, 3, 5, 'Covilhão', 1),
(63, 4, 5, 'Fundão', 1),
(64, 5, 5, 'Idanha-A-Nova', 1),
(65, 6, 5, 'Oleiros', 1),
(66, 7, 5, 'Penamacor', 1),
(67, 8, 5, 'Proença-A-Nova', 1),
(68, 9, 5, 'Sertão', 1),
(69, 10, 5, 'Vila De Rei', 1),
(70, 11, 5, 'Vila Velha De Ródão', 1),
(71, 1, 6, 'Arganil', 1),
(72, 2, 6, 'Cantanhede', 1),
(73, 3, 6, 'Coimbra', 1),
(74, 4, 6, 'Condeixa-A-Nova', 1),
(75, 5, 6, 'Figueira Da Foz', 1),
(76, 6, 6, 'Góis', 1),
(77, 7, 6, 'Lousão', 1),
(78, 8, 6, 'Mira', 1),
(79, 9, 6, 'Miranda Do Corvo', 1),
(80, 10, 6, 'Montemor-O-Velho', 1),
(81, 11, 6, 'Oliveira Do Hospital', 1),
(82, 12, 6, 'Pampilhosa Da Serra', 1),
(83, 13, 6, 'Penacova', 1),
(84, 14, 6, 'Penela', 1),
(85, 15, 6, 'Soure', 1),
(86, 16, 6, 'Tábua', 1),
(87, 17, 6, 'Vila Nova De Poiares', 1),
(88, 1, 7, 'Alandroal', 1),
(89, 2, 7, 'Arraiolos', 1),
(90, 3, 7, 'Borba', 1),
(91, 4, 7, 'Estremoz', 1),
(92, 5, 7, 'Évora', 1),
(93, 6, 7, 'Montemor-O-Novo', 1),
(94, 7, 7, 'Mora', 1),
(95, 8, 7, 'Mourão', 1),
(96, 9, 7, 'Portel', 1),
(97, 10, 7, 'Redondo', 1),
(98, 11, 7, 'Reguengos De Monsaraz', 1),
(99, 12, 7, 'Vendas Novas', 1),
(100, 13, 7, 'Viana Do Alentejo', 1),
(101, 14, 7, 'Vila Viçosa', 1),
(102, 1, 8, 'Albufeira', 1),
(103, 2, 8, 'Alcoutim', 1),
(104, 3, 8, 'Aljezur', 1),
(105, 4, 8, 'Castro Marim', 1),
(106, 5, 8, 'Faro', 1),
(107, 6, 8, 'Lagoa (Algarve)', 1),
(108, 7, 8, 'Lagos', 1),
(109, 8, 8, 'Loulé', 1),
(110, 9, 8, 'Monchique', 1),
(111, 10, 8, 'Olhão', 1),
(112, 11, 8, 'Portimão', 1),
(113, 12, 8, 'São Brás De Alportel', 1),
(114, 13, 8, 'Silves', 1),
(115, 14, 8, 'Tavira', 1),
(116, 15, 8, 'Vila Do Bispo', 1),
(117, 16, 8, 'Vila Real De Santo António', 1),
(118, 1, 9, 'Aguiar Da Beira', 1),
(119, 2, 9, 'Almeida', 1),
(120, 3, 9, 'Celorico Da Beira', 1),
(121, 4, 9, 'Figueira De Castelo Rodrigo', 1),
(122, 5, 9, 'Fornos De Algodres', 1),
(123, 6, 9, 'Gouveia', 1),
(124, 7, 9, 'Guarda', 1),
(125, 8, 9, 'Manteigas', 1),
(126, 9, 9, 'Mêda', 1),
(127, 10, 9, 'Pinhel', 1),
(128, 11, 9, 'Sabugal', 1),
(129, 12, 9, 'Seia', 1),
(130, 13, 9, 'Trancoso', 1),
(131, 14, 9, 'Vila Nova De Foz Côa', 1),
(132, 1, 10, 'Alcobaça', 1),
(133, 2, 10, 'Alvaiázere', 1),
(134, 3, 10, 'Ansião', 1),
(135, 4, 10, 'Batalha', 1),
(136, 5, 10, 'Bombarral', 1),
(137, 6, 10, 'Caldas Da Rainha', 1),
(138, 7, 10, 'Castanheira De Pêra', 1),
(139, 8, 10, 'Figueiró Dos Vinhos', 1),
(140, 9, 10, 'Leiria', 1),
(141, 10, 10, 'Marinha Grande', 1),
(142, 11, 10, 'Nazaré', 1),
(143, 12, 10, 'í“bidos', 1),
(144, 13, 10, 'Pedrógão Grande', 1),
(145, 14, 10, 'Peniche', 1),
(146, 15, 10, 'Pombal', 1),
(147, 16, 10, 'Porto De Mós', 1),
(148, 1, 11, 'Alenquer', 1),
(149, 2, 11, 'Arruda Dos Vinhos', 1),
(150, 3, 11, 'Azambuja', 1),
(151, 4, 11, 'Cadaval', 1),
(152, 5, 11, 'Cascais', 1),
(153, 6, 11, 'Lisboa', 1),
(154, 7, 11, 'Loures', 1),
(155, 8, 11, 'Lourinhão', 1),
(156, 9, 11, 'Mafra', 1),
(157, 10, 11, 'Oeiras', 1),
(158, 11, 11, 'Sintra', 1),
(159, 12, 11, 'Sobral De Monte Agraço', 1),
(160, 13, 11, 'Torres Vedras', 1),
(161, 14, 11, 'Vila Franca De Xira', 1),
(162, 15, 11, 'Amadora', 1),
(163, 16, 11, 'Odivelas', 1),
(164, 1, 12, 'Alter Do Chão', 1),
(165, 2, 12, 'Arronches', 1),
(166, 3, 12, 'Avis', 1),
(167, 4, 12, 'Campo Maior', 1),
(168, 5, 12, 'Castelo De Vide', 1),
(169, 6, 12, 'Crato', 1),
(170, 7, 12, 'Elvas', 1),
(171, 8, 12, 'Fronteira', 1),
(172, 9, 12, 'Gavião', 1),
(173, 10, 12, 'Marvão', 1),
(174, 11, 12, 'Monforte', 1),
(175, 12, 12, 'Nisa', 1),
(176, 13, 12, 'Ponte De Sor', 1),
(177, 14, 12, 'Portalegre', 1),
(178, 15, 12, 'Sousel', 1),
(179, 1, 13, 'Amarante', 1),
(180, 2, 13, 'Baião', 1),
(181, 3, 13, 'Felgueiras', 1),
(182, 4, 13, 'Gondomar', 1),
(183, 5, 13, 'Lousada', 1),
(184, 6, 13, 'Maia', 1),
(185, 7, 13, 'Marco De Canaveses', 1),
(186, 8, 13, 'Matosinhos', 1),
(187, 9, 13, 'Paços De Ferreira', 1),
(188, 10, 13, 'Paredes', 1),
(189, 11, 13, 'Penafiel', 1),
(190, 12, 13, 'Porto', 1),
(191, 13, 13, 'Póvoa De Varzim', 1),
(192, 14, 13, 'Santo Tirso', 1),
(193, 15, 13, 'Valongo', 1),
(194, 16, 13, 'Vila Do Conde', 1),
(195, 17, 13, 'Vila Nova De Gaia', 1),
(196, 18, 13, 'Trofa', 1),
(197, 1, 14, 'Abrantes', 1),
(198, 2, 14, 'Alcanena', 1),
(199, 3, 14, 'Almeirim', 1),
(200, 4, 14, 'Alpiarça', 1),
(201, 5, 14, 'Benavente', 1),
(202, 6, 14, 'Cartaxo', 1),
(203, 7, 14, 'Chamusca', 1),
(204, 8, 14, 'Constância', 1),
(205, 9, 14, 'Coruche', 1),
(206, 10, 14, 'Entroncamento', 1),
(207, 11, 14, 'Ferreira Do Zêzere', 1),
(208, 12, 14, 'Golegão', 1),
(209, 13, 14, 'Mação', 1),
(210, 14, 14, 'Rio Maior', 1),
(211, 15, 14, 'Salvaterra De Magos', 1),
(212, 16, 14, 'Santarém', 1),
(213, 17, 14, 'Sardoal', 1),
(214, 18, 14, 'Tomar', 1),
(215, 19, 14, 'Torres Novas', 1),
(216, 20, 14, 'Vila Nova Da Barquinha', 1),
(217, 21, 14, 'Ourém', 1),
(218, 1, 15, 'Alcácer Do Sal', 1),
(219, 2, 15, 'Alcochete', 1),
(220, 3, 15, 'Almada', 1),
(221, 4, 15, 'Barreiro', 1),
(222, 5, 15, 'Grândola', 1),
(223, 6, 15, 'Moita', 1),
(224, 7, 15, 'Montijo', 1),
(225, 8, 15, 'Palmela', 1),
(226, 9, 15, 'Santiago Do Cacém', 1),
(227, 10, 15, 'Seixal', 1),
(228, 11, 15, 'Sesimbra', 1),
(229, 12, 15, 'Setúbal', 1),
(230, 13, 15, 'Sines', 1),
(231, 1, 16, 'Arcos De Valdevez', 1),
(232, 2, 16, 'Caminha', 1),
(233, 3, 16, 'Melgaço', 1),
(234, 4, 16, 'Monção', 1),
(235, 5, 16, 'Paredes De Coura', 1),
(236, 6, 16, 'Ponte Da Barca', 1),
(237, 7, 16, 'Ponte De Lima', 1),
(238, 8, 16, 'Valença', 1),
(239, 9, 16, 'Viana Do Castelo', 1),
(240, 10, 16, 'Vila Nova De Cerveira', 1),
(241, 1, 17, 'Alijó', 1),
(242, 2, 17, 'Boticas', 1),
(243, 3, 17, 'Chaves', 1),
(244, 4, 17, 'Mesão Frio', 1),
(245, 5, 17, 'Mondim De Basto', 1),
(246, 6, 17, 'Montalegre', 1),
(247, 7, 17, 'Murça', 1),
(248, 8, 17, 'Peso Da Régua', 1),
(249, 9, 17, 'Ribeira De Pena', 1),
(250, 10, 17, 'Sabrosa', 1),
(251, 11, 17, 'Santa Marta De Penaguião', 1),
(252, 12, 17, 'Valpaços', 1),
(253, 13, 17, 'Vila Pouca De Aguiar', 1),
(254, 14, 17, 'Vila Real', 1),
(255, 1, 18, 'Armamar', 1),
(256, 2, 18, 'Carregal Do Sal', 1),
(257, 3, 18, 'Castro Daire', 1),
(258, 4, 18, 'Cinfãoes', 1),
(259, 5, 18, 'Lamego', 1),
(260, 6, 18, 'Mangualde', 1),
(261, 7, 18, 'Moimenta Da Beira', 1),
(262, 8, 18, 'Mortágua', 1),
(263, 9, 18, 'Nelas', 1),
(264, 10, 18, 'Oliveira De Frades', 1),
(265, 11, 18, 'Penalva Do Castelo', 1),
(266, 12, 18, 'Penedono', 1),
(267, 13, 18, 'Resende', 1),
(268, 14, 18, 'Santa Comba Dão', 1),
(269, 15, 18, 'São João Da Pesqueira', 1),
(270, 16, 18, 'São Pedro Do Sul', 1),
(271, 17, 18, 'Sátão', 1),
(272, 18, 18, 'Sernancelhe', 1),
(273, 19, 18, 'Tabuaço', 1),
(274, 20, 18, 'Tarouca', 1),
(275, 21, 18, 'Tondela', 1),
(276, 22, 18, 'Vila Nova De Paiva', 1),
(277, 23, 18, 'Viseu', 1),
(278, 24, 18, 'Vouzela', 1),
(279, 1, 31, 'Calheta (Madeira)', 1),
(280, 2, 31, 'Câmara De Lobos', 1),
(281, 3, 31, 'Funchal', 1),
(282, 4, 31, 'Machico', 1),
(283, 5, 31, 'Ponta Do Sol', 1),
(284, 6, 31, 'Porto Moniz', 1),
(285, 7, 31, 'Ribeira Brava', 1),
(286, 8, 31, 'Santa Cruz', 1),
(287, 9, 31, 'Santana', 1),
(288, 10, 31, 'São Vicente', 1),
(289, 1, 32, 'Porto Santo', 1),
(290, 1, 41, 'Vila Do Porto', 1),
(291, 2, 42, 'Nordeste', 1),
(292, 3, 42, 'Ponta Delgada', 1),
(293, 4, 42, 'Povoação', 1),
(294, 5, 42, 'Ribeira Grande', 1),
(295, 6, 42, 'Vila Franca Do Campo', 1),
(296, 1, 43, 'Angra Do Heroí­smo', 1),
(297, 2, 43, 'Praia Da Vitória', 1),
(298, 1, 44, 'Santa Cruz Da Graciosa', 1),
(299, 1, 45, 'Calheta (São Jorge)', 1),
(300, 2, 45, 'Velas', 1),
(301, 1, 46, 'Lajes Do Pico', 1),
(302, 2, 46, 'Madalena', 1),
(303, 3, 46, 'São Roque Do Pico', 1),
(304, 1, 47, 'Horta', 1),
(305, 1, 48, 'Lajes Das Flores', 1),
(306, 2, 48, 'Santa Cruz Das Flores', 1),
(307, 1, 49, 'Corvo', 1),
(308, 1, 42, 'Lagoa (São Miguel)', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_dashboard`
--

DROP TABLE IF EXISTS `core_dashboard`;
CREATE TABLE IF NOT EXISTS `core_dashboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `opcao` int(11) NOT NULL DEFAULT 1,
  `espaco` int(11) NOT NULL DEFAULT 1,
  `tipo` int(11) NOT NULL DEFAULT 1,
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_dashboard`
--

INSERT INTO `core_dashboard` (`id`, `titulo`, `opcao`, `espaco`, `tipo`, `is_active`) VALUES
(1, 'Dashboard', 1, 1, 1, 1),
(2, 'Uploads', 2, 2, 2, 1),
(3, 'Vendas', 3, 3, 3, 1),
(4, 'Uploads', 2, 4, 4, 1),
(5, 'Produtos', 4, 1, 1, 1),
(6, 'Categorias', 5, 1, 5, 1),
(7, 'Cidades', 6, 1, 6, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_departamento`
--

DROP TABLE IF EXISTS `core_departamento`;
CREATE TABLE IF NOT EXISTS `core_departamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cod` varchar(20) NOT NULL,
  `descricao` varchar(150) NOT NULL,
  `idemp` int(11) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_departamento`
--

INSERT INTO `core_departamento` (`id`, `cod`, `descricao`, `idemp`, `created_at`, `is_active`) VALUES
(1, 'G', 'GERAL', 1, '2025-01-01 00:00:00', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_distritos`
--

DROP TABLE IF EXISTS `core_distritos`;
CREATE TABLE IF NOT EXISTS `core_distritos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(255) NOT NULL DEFAULT '',
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_distritos`
--

INSERT INTO `core_distritos` (`id`, `descricao`, `is_active`) VALUES
(1, 'Aveiro', 1),
(2, 'Beja', 1),
(3, 'Braga', 1),
(4, 'Bragança', 1),
(5, 'Castelo Branco', 1),
(6, 'Coimbra', 1),
(7, 'Évora', 1),
(8, 'Faro', 1),
(9, 'Guarda', 1),
(10, 'Leiria', 1),
(11, 'Lisboa', 1),
(12, 'Portalegre', 1),
(13, 'Porto', 1),
(14, 'Santarém', 1),
(15, 'Setúbal', 1),
(16, 'Viana do Castelo', 1),
(17, 'Vila Real', 1),
(18, 'Viseu', 1),
(31, 'Ilha da Madeira', 1),
(32, 'Ilha de Porto Santo', 1),
(41, 'Ilha de Santa Maria', 1),
(42, 'Ilha de São Miguel', 1),
(43, 'Ilha Terceira', 1),
(44, 'Ilha da Graciosa', 1),
(45, 'Ilha de São Jorge', 1),
(46, 'Ilha do Pico', 1),
(47, 'Ilha do Faial', 1),
(48, 'Ilha das Flores', 1),
(49, 'Ilha do Corvo', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_documento_tipo`
--

DROP TABLE IF EXISTS `core_documento_tipo`;
CREATE TABLE IF NOT EXISTS `core_documento_tipo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) DEFAULT NULL,
  `prio` int(11) NOT NULL DEFAULT 0,
  `act` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `core_documento_tipo`
--

INSERT INTO `core_documento_tipo` (`id`, `descricao`, `prio`, `act`) VALUES
(1, 'Licença', 1, 1),
(2, 'Seguro', 1, 1),
(3, 'Declaração', 0, 1),
(4, 'Declaração Menores', 0, 2),
(5, 'Outros', 0, 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_empresa`
--

DROP TABLE IF EXISTS `core_empresa`;
CREATE TABLE IF NOT EXISTS `core_empresa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_idioma` int(11) NOT NULL DEFAULT 1,
  `nome` varchar(255) NOT NULL,
  `logo` varchar(255) NOT NULL,
  `icon` varchar(255) NOT NULL DEFAULT '',
  `actcod` varchar(255) NOT NULL,
  `nif` varchar(50) NOT NULL,
  `morada` text DEFAULT NULL,
  `condicoes` longtext NOT NULL,
  `serial` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_core_empresa_core_user` (`id_user`) USING BTREE,
  KEY `FK_core_empresa_core_idioma` (`id_idioma`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_empresa`
--

INSERT INTO `core_empresa` (`id`, `id_user`, `id_idioma`, `nome`, `logo`, `icon`, `actcod`, `nif`, `morada`, `condicoes`, `serial`, `created_at`, `is_active`, `username`, `password`) VALUES
(1, 1, 1, 'Base', 'img/ok4-03.png', 'img/ok4-03.png', 'e3050ac35059b5733f7e1b2d9fe873a02f44fb7e', '1', NULL, '1', '', '2025-03-20 09:42:01', 1, 'info@alentapp.pt', '123');

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_funcao`
--

DROP TABLE IF EXISTS `core_funcao`;
CREATE TABLE IF NOT EXISTS `core_funcao` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(150) NOT NULL,
  `ordem` int(3) NOT NULL DEFAULT 1,
  `id_depart` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_core_funcao_core_departamento` (`id_depart`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_funcao`
--

INSERT INTO `core_funcao` (`id`, `descricao`, `ordem`, `id_depart`, `created_at`, `is_active`) VALUES
(1, 'Administrador', 1, 1, '2025-02-14 13:24:28', 1),
(2, 'Gerente', 1, 1, '2025-02-14 13:24:28', 1),
(3, 'Coordenador', 1, 1, '2025-02-14 13:24:28', 1),
(4, 'Administrativo', 1, 1, '2025-02-14 13:24:28', 1),
(5, 'Analista', 1, 1, '2025-02-14 13:24:28', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_idioma`
--

DROP TABLE IF EXISTS `core_idioma`;
CREATE TABLE IF NOT EXISTS `core_idioma` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acro` varchar(10) NOT NULL DEFAULT '',
  `descricao` varchar(50) NOT NULL,
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_idioma`
--

INSERT INTO `core_idioma` (`id`, `acro`, `descricao`, `is_active`) VALUES
(1, 'pt', 'Português', 1),
(2, 'gb', 'Inglês', 1),
(3, 'fr', 'Francês', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_login`
--

DROP TABLE IF EXISTS `core_login`;
CREATE TABLE IF NOT EXISTS `core_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo` int(11) NOT NULL DEFAULT 1,
  `id_lang` int(11) NOT NULL DEFAULT 1,
  `id_user` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `pass` varchar(100) NOT NULL,
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_core_login_core_tipologin` (`id_tipo`) USING BTREE,
  KEY `idlang` (`id_lang`) USING BTREE,
  KEY `FK_core_login_core_user` (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_login`
--

INSERT INTO `core_login` (`id`, `id_tipo`, `id_lang`, `id_user`, `username`, `pass`, `is_active`) VALUES
(1, 1, 1, 1, 'admin', '2c7ba88fd19ed9ea74d0d85a7eb2619d', 1),
(7, 1, 1, 8, 'analista', 'ad58b9e10a3fb7061065e70b4a80e56f', 1),
(8, 1, 1, 9, 'asdasdsa', 'a16be1b755e1941fb7f46e8b12727071', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_module`
--

DROP TABLE IF EXISTS `core_module`;
CREATE TABLE IF NOT EXISTS `core_module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cod` varchar(50) NOT NULL,
  `descricao` varchar(150) NOT NULL,
  `icon` varchar(50) NOT NULL DEFAULT '0',
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_module`
--

INSERT INTO `core_module` (`id`, `cod`, `descricao`, `icon`, `is_active`) VALUES
(1, 'core', 'Backoffice', 'fas fa-cogs', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_notification`
--

DROP TABLE IF EXISTS `core_notification`;
CREATE TABLE IF NOT EXISTS `core_notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_sent` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_core_notification_core_user` (`id_user`),
  KEY `FK_core_notification_core_user_2` (`id_sent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_pais`
--

DROP TABLE IF EXISTS `core_pais`;
CREATE TABLE IF NOT EXISTS `core_pais` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) DEFAULT NULL,
  `cod` varchar(50) DEFAULT NULL,
  `cod_lang` varchar(50) DEFAULT 'pt-PT',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `core_pais`
--

INSERT INTO `core_pais` (`id`, `descricao`, `cod`, `cod_lang`) VALUES
(1, 'Portugal', 'PT', 'pt-PT'),
(2, 'Espanha', 'ES', 'es-ES'),
(3, 'França', 'FR', 'fr-FR'),
(4, 'Alemanha', 'DE', 'de-DE'),
(5, 'Itália', 'IT', 'it-IT'),
(6, 'Reino Unido', 'GB', 'en-GB'),
(7, 'Brasil', 'BR', 'pt-PT'),
(8, 'Estados Unidos', 'US', 'en-US'),
(9, 'Japão', 'JP', 'ja-JP'),
(10, 'China', 'CN', 'zh-CN'),
(11, 'Índia', 'IN', 'hi-IN'),
(12, 'Canadá', 'CA', 'en-CA'),
(13, 'Austrália', 'AU', 'en-AU'),
(14, 'México', 'MX', 'es-MX'),
(15, 'Argentina', 'AR', 'es-AR'),
(16, 'Rússia', 'RU', 'ru-RU'),
(17, 'Coreia do Sul', 'KR', 'ko-KR'),
(18, 'África do Sul', 'ZA', 'en-ZA'),
(19, 'Holanda', 'NL', 'nl-NL'),
(20, 'Suíça', 'CH', 'de-CH'),
(21, 'Irlanda', 'IE', 'en-IE'),
(22, 'Noruega', 'NO', 'no-NO'),
(23, 'Polônia', 'PL', 'pl-PL'),
(24, 'Letônia', 'LV', 'lv-LV'),
(25, 'Islândia', 'IS', 'is-IS'),
(26, 'Luxemburgo', 'LU', 'fr-LU'),
(27, 'Romênia', 'RO', 'ro-RO'),
(28, 'Angola', 'AO', 'pt-AO'),
(29, 'Suécia', 'SE', 'sv-SE'),
(30, 'Geórgia', 'GE', 'ka-GE'),
(31, 'Bélgica', 'BE', 'nl-BE'),
(32, 'Eslováquia', 'SK', 'sk-SK'),
(33, 'Dinamarca', 'DK', 'da-DK'),
(34, 'Croácia', 'HR', 'hr-HR'),
(35, 'Israel', 'IL', 'he-IL'),
(36, 'Lituânia', 'LT', 'lt-LT'),
(37, 'Chipre', 'CY', 'el-CY'),
(38, 'Grécia', 'GR', 'el-GR'),
(39, 'Malásia', 'MY', 'ms-MY'),
(40, 'Áustria', 'AT', 'de-AT'),
(41, 'Omã', 'OM', 'ar-OM'),
(42, 'Finlândia', 'FI', 'fi-FI'),
(43, 'Ucrânia', 'UA', 'uk-UA'),
(44, 'Indonésia', 'ID', 'id-ID'),
(45, 'Catar', 'QA', 'ar-QA'),
(46, 'Afeganistão', 'AF', 'ps-AF');

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_permissao`
--

DROP TABLE IF EXISTS `core_permissao`;
CREATE TABLE IF NOT EXISTS `core_permissao` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo` int(11) NOT NULL,
  `descricao` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `notas` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_core_permissao_core_tipopermissao` (`id_tipo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_permissao`
--

INSERT INTO `core_permissao` (`id`, `id_tipo`, `descricao`, `notas`) VALUES
(1, 1, 'Ver', 'Ver página e informações'),
(2, 1, 'Adicionar', 'Adicionar informações'),
(3, 1, 'Editar', 'Editar infomações'),
(4, 1, 'Gerir', 'Ativar e desativar opções'),
(5, 2, 'Ver', 'Ver página e informações'),
(6, 2, 'Adicionar', 'Adicionar informações'),
(7, 2, 'Editar', 'Editar infomações'),
(8, 2, 'Gerir', 'Ativar e desativar opções'),
(9, 3, 'Ver', 'Ver página e informações'),
(10, 3, 'Adicionar', 'Adicionar informações'),
(11, 3, 'Editar', 'Editar infomações'),
(12, 3, 'Gerir', 'Ativar e desativar opções'),
(13, 4, 'Ver', 'Ver página e informações'),
(14, 4, 'Adicionar', 'Adicionar informações'),
(15, 4, 'Editar', 'Editar infomações'),
(16, 4, 'Gerir', 'Ativar e desativar opções'),
(17, 1, 'Apagar', 'Apagar informações'),
(18, 1, 'Importar', 'Importar CSV'),
(19, 4, 'Apagar', 'Apagar informações'),
(20, 4, 'Importar', 'Importar CSV');

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_rel_tipouser_permissao`
--

DROP TABLE IF EXISTS `core_rel_tipouser_permissao`;
CREATE TABLE IF NOT EXISTS `core_rel_tipouser_permissao` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo` int(11) NOT NULL,
  `id_perm` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_core_rel_tipouser_permissao_core_tipouser` (`id_tipo`) USING BTREE,
  KEY `FK_core_rel_tipouser_permissao_core_permissao` (`id_perm`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_rel_tipouser_permissao`
--

INSERT INTO `core_rel_tipouser_permissao` (`id`, `id_tipo`, `id_perm`) VALUES
(1, 1, 1),
(2, 1, 17),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 1, 6),
(7, 1, 7),
(8, 1, 8),
(9, 1, 9),
(10, 1, 10),
(11, 1, 11),
(12, 1, 12),
(13, 1, 13),
(14, 1, 14),
(15, 1, 15),
(16, 1, 16),
(18, 1, 18),
(41, 1, 2),
(43, 2, 9),
(44, 2, 10),
(45, 2, 11),
(46, 2, 12),
(63, 4, 5),
(64, 4, 6),
(65, 4, 7),
(66, 4, 8),
(67, 4, 9),
(68, 4, 10),
(69, 4, 11),
(70, 4, 12),
(107, 4, 13),
(110, 4, 16),
(111, 5, 1),
(112, 1, 19),
(113, 1, 20),
(114, 5, 13);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_tipocont`
--

DROP TABLE IF EXISTS `core_tipocont`;
CREATE TABLE IF NOT EXISTS `core_tipocont` (
  `id` int(11) NOT NULL,
  `descricao` varchar(50) DEFAULT NULL,
  `nferias` int(11) DEFAULT NULL,
  `contador` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_tipocont`
--

INSERT INTO `core_tipocont` (`id`, `descricao`, `nferias`, `contador`) VALUES
(1, 'Sem Contrato', 0, 8),
(2, 'Sem Termo', 22, 8),
(3, 'Estágio', 0, 8),
(4, 'Part-Time Vertical', 22, 4),
(5, 'Part-Time Horizontal', 22, 4),
(6, 'Termo 6 Meses', 11, 8),
(7, 'Termo 1 Ano', 22, 8);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_tipologin`
--

DROP TABLE IF EXISTS `core_tipologin`;
CREATE TABLE IF NOT EXISTS `core_tipologin` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador',
  `descricao` varchar(50) NOT NULL COMMENT 'Designação',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1 COMMENT 'Estado',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_tipologin`
--

INSERT INTO `core_tipologin` (`id`, `descricao`, `created_at`, `is_active`) VALUES
(1, 'Utilizador', '2025-01-01 00:00:01', 1),
(2, 'Cliente', '2025-01-01 00:00:02', 1),
(3, 'Fornecedor', '2025-01-01 00:00:01', 1),
(4, 'Externo', '2025-01-01 00:00:01', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_tipopermissao`
--

DROP TABLE IF EXISTS `core_tipopermissao`;
CREATE TABLE IF NOT EXISTS `core_tipopermissao` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_module` int(11) NOT NULL,
  `url` varchar(250) NOT NULL DEFAULT '',
  `cod` varchar(50) NOT NULL,
  `descricao` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `icon` varchar(50) NOT NULL,
  `sub` int(11) NOT NULL,
  `page` int(11) NOT NULL,
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_core_tipopermissao_pro_module` (`id_module`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_tipopermissao`
--

INSERT INTO `core_tipopermissao` (`id`, `id_module`, `url`, `cod`, `descricao`, `icon`, `sub`, `page`, `is_active`) VALUES
(1, 1, 'module/core/permissoes.html', 'permissoes', 'Permissões', 'fas fa-users-cog', 1, 1, 1),
(2, 1, 'module/core/tabelasAuxiliares.html', 'tabelasAuxiliares', 'Tabelas Auxiliares', 'fas fa-table', 1, 2, 1),
(3, 1, 'module/core/utilizadores.html', 'utilizadores', 'Utilizadores', 'fa fa-address-book', 1, 3, 1),
(4, 1, 'module/core/dashboard.html', 'dashboard', 'Dashboard', 'fa fa-th-large', 0, 4, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_tipouser`
--

DROP TABLE IF EXISTS `core_tipouser`;
CREATE TABLE IF NOT EXISTS `core_tipouser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_tipouser`
--

INSERT INTO `core_tipouser` (`id`, `descricao`, `created_at`, `is_active`) VALUES
(1, 'Administrador', '2025-01-01 00:00:00', 1),
(2, 'Coordenador', '2025-01-01 00:00:00', 1),
(3, 'Colaborador', '2025-01-01 00:00:00', 1),
(4, 'Administração', '2025-01-01 00:00:00', 1),
(5, 'Analista', '2025-01-01 00:00:00', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_user`
--

DROP TABLE IF EXISTS `core_user`;
CREATE TABLE IF NOT EXISTS `core_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipouser` int(11) NOT NULL DEFAULT 1,
  `id_tipocont` int(11) NOT NULL DEFAULT 1,
  `id_funcao` int(11) NOT NULL DEFAULT 1,
  `id_departamento` int(11) NOT NULL DEFAULT 1,
  `id_hl` int(11) NOT NULL DEFAULT 1,
  `id_sexo` int(11) NOT NULL DEFAULT 1,
  `cod` varchar(20) NOT NULL,
  `abre` varchar(20) DEFAULT '',
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `contacto` varchar(100) NOT NULL,
  `cor` varchar(10) NOT NULL DEFAULT '#000000',
  `img` varchar(255) NOT NULL DEFAULT 'img/user.png',
  `dtnasc` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_core_user_core_tipouser` (`id_tipouser`),
  KEY `FK_core_user_core_tipocont` (`id_tipocont`),
  KEY `FK_core_user_core_funcao` (`id_funcao`),
  KEY `FK_core_user_core_departamento` (`id_departamento`),
  KEY `FK_core_user_core_user_hl` (`id_hl`),
  KEY `FK_core_user_core_user_sexo` (`id_sexo`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_user`
--

INSERT INTO `core_user` (`id`, `id_tipouser`, `id_tipocont`, `id_funcao`, `id_departamento`, `id_hl`, `id_sexo`, `cod`, `abre`, `nome`, `email`, `contacto`, `cor`, `img`, `dtnasc`, `created_at`, `is_active`) VALUES
(1, 1, 1, 1, 1, 1, 1, '000', 'admin', 'Administrador', 'admin', '912312312', '#000000', 'img/user.png', NULL, '2025-01-01 00:00:08', 1),
(8, 5, 1, 5, 1, 1, 1, '001', '', 'Analista', 'analista', '000000', '#000000', 'img/user.png', NULL, '2026-02-24 15:12:45', 1),
(9, 5, 1, 5, 1, 1, 1, '002', '', 'analista2', 'asdasdsa', 'assdasd', '#000000', 'img/user.png', NULL, '2026-02-24 15:17:20', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_user_dash`
--

DROP TABLE IF EXISTS `core_user_dash`;
CREATE TABLE IF NOT EXISTS `core_user_dash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_dash` int(11) NOT NULL,
  `ordem` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_core_user_dash_core_user` (`id_user`) USING BTREE,
  KEY `FK_core_user_dash_core_dashboard` (`id_dash`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_user_dash`
--

INSERT INTO `core_user_dash` (`id`, `id_user`, `id_dash`, `ordem`) VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(21, 1, 3, 3),
(22, 1, 5, 4),
(23, 8, 1, 1),
(24, 9, 1, 1),
(27, 8, 3, 3),
(28, 9, 3, 3),
(29, 8, 5, 4),
(30, 9, 5, 4),
(38, 1, 6, 5),
(39, 8, 6, 5),
(41, 1, 7, 6),
(42, 8, 7, 6);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_user_hl`
--

DROP TABLE IF EXISTS `core_user_hl`;
CREATE TABLE IF NOT EXISTS `core_user_hl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) NOT NULL,
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_user_hl`
--

INSERT INTO `core_user_hl` (`id`, `descricao`, `is_active`) VALUES
(1, '7º', 1),
(2, '9º', 1),
(3, '12º', 1),
(4, 'BAC', 1),
(5, 'SEM EQUIVALENTE', 1),
(6, 'LICENCIATURA', 1),
(7, 'MESTRADO', 1),
(8, 'DOUTORAMENTO', 1),
(9, 'MBA', 1),
(10, 'Sem Infomação', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_user_sexo`
--

DROP TABLE IF EXISTS `core_user_sexo`;
CREATE TABLE IF NOT EXISTS `core_user_sexo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) NOT NULL,
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `core_user_sexo`
--

INSERT INTO `core_user_sexo` (`id`, `descricao`, `is_active`) VALUES
(1, 'Sem Informação', 1),
(2, 'Masculino', 1),
(3, 'Feminino', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `produtos`
--

DROP TABLE IF EXISTS `produtos`;
CREATE TABLE IF NOT EXISTS `produtos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_produto` int(11) DEFAULT NULL,
  `descricao` varchar(100) NOT NULL,
  `quantidade` int(11) DEFAULT NULL,
  `preco_uni` double NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_produtos_id_tipo_produto` (`id_tipo_produto`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `produtos`
--

INSERT INTO `produtos` (`id`, `id_tipo_produto`, `descricao`, `quantidade`, `preco_uni`, `created_at`, `updated_at`) VALUES
(81, 1, 'Bola Street', NULL, 12, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(82, 1, 'Garrafa', NULL, 12, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(83, 1, 'Bola Pro', NULL, 12, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(84, 1, 'Mochila', NULL, 12, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(85, 2, 'Bilhete Jogo Feminino', NULL, 15, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(86, 2, 'Bilhete Jogo Taça', NULL, 15, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(87, 2, 'Bilhete Jogo Liga', NULL, 15, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(88, 2, 'Bilhete Derby', NULL, 15, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(89, 2, 'Bilhete Derby', NULL, 18, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(90, 1, 'Calções', NULL, 18, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(91, 1, 'Camisola Treino', NULL, 18, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(92, 1, 'Boné', NULL, 18, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(93, 2, 'Bilhete Jogo Taça', NULL, 18, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(94, 2, 'Bilhete Jogo Feminino', NULL, 18, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(95, 2, 'Bilhete Jogo Liga', NULL, 18, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(96, 1, 'Camisola Oficial', NULL, 18, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(97, 1, 'Mochila', NULL, 22, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(98, 2, 'Bilhete Jogo Feminino', NULL, 22, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(99, 2, 'Bilhete Derby', NULL, 22, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(100, 2, 'Bilhete Jogo Taça', NULL, 22, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(101, 1, 'Bola Pro', NULL, 22, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(102, 1, 'Garrafa', NULL, 22, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(103, 2, 'Bilhete Jogo Liga', NULL, 22, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(104, 2, 'Bilhete Derby', NULL, 25, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(105, 2, 'Bilhete Jogo Feminino', NULL, 25, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(106, 2, 'Bilhete Jogo Taça', NULL, 25, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(107, 1, 'Camisola Oficial', NULL, 25, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(108, 2, 'Bilhete Jogo Liga', NULL, 25, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(109, 1, 'Calções', NULL, 25, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(110, 1, 'Camisola Treino', NULL, 25, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(111, 1, 'Calções', NULL, 29, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(112, 1, 'Camisola Oficial', NULL, 29, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(113, 1, 'Camisola Treino', NULL, 29, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(114, 1, 'Boné', NULL, 29, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(115, 1, 'Mochila', NULL, 35, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(116, 1, 'Garrafa', NULL, 35, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(117, 1, 'Bola Street', NULL, 35, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(118, 1, 'Bola Pro', NULL, 35, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(119, 1, 'Bola Pro', NULL, 40, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(120, 1, 'Bola Street', NULL, 40, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(121, 1, 'Garrafa', NULL, 40, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(122, 1, 'Boné', NULL, 49, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(123, 1, 'Calções', NULL, 49, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(124, 1, 'Camisola Oficial', NULL, 49, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(125, 1, 'Camisola Treino', NULL, 49, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(126, 3, 'Workshop Treinadores', NULL, 50, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(127, 3, 'Clinic Jovem', NULL, 50, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(128, 3, 'Workshop Arbitragem', NULL, 50, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(129, 3, 'Clinic Lançamento', NULL, 50, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(130, 3, 'Workshop Treinadores', NULL, 60, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(131, 3, 'Workshop Arbitragem', NULL, 60, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(132, 3, 'Clinic Jovem', NULL, 60, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(133, 3, 'Clinic Lançamento', NULL, 60, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(134, 3, 'Workshop Arbitragem', NULL, 70, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(135, 3, 'Clinic Lançamento', NULL, 70, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(136, 3, 'Clinic Jovem', NULL, 70, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(137, 3, 'Workshop Treinadores', NULL, 80, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(138, 3, 'Clinic Lançamento', NULL, 80, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(139, 3, 'Clinic Jovem', NULL, 80, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(140, 3, 'Workshop Arbitragem', NULL, 80, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(141, 1, 'Bola Street', NULL, 22, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(142, 1, 'Boné', NULL, 25, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(143, 1, 'Mochila', NULL, 40, '2026-02-28 20:50:42', '2026-02-28 20:50:42'),
(144, 3, 'Workshop Treinadores', NULL, 70, '2026-02-28 20:50:42', '2026-02-28 20:50:42');

-- --------------------------------------------------------

--
-- Estrutura da tabela `session_messages`
--

DROP TABLE IF EXISTS `session_messages`;
CREATE TABLE IF NOT EXISTS `session_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text NOT NULL COMMENT 'Texto da mensagem',
  `type` enum('start','end') NOT NULL COMMENT 'Tipo da mensagem: início ou fim da sessão',
  `type_event` enum('birthday','christmas','new year') DEFAULT NULL,
  `date` date DEFAULT NULL,
  `emoji` varchar(10) DEFAULT NULL COMMENT 'Emoji para mensagem de início',
  `id_user` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Define se a mensagem está ativa',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `type` (`type`) USING BTREE,
  KEY `FK_session_messages_core_user` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Mensagem única para início e fim de sessão';

-- --------------------------------------------------------

--
-- Estrutura da tabela `session_messages_users`
--

DROP TABLE IF EXISTS `session_messages_users`;
CREATE TABLE IF NOT EXISTS `session_messages_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_session` int(11) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_session_messages_users_session_messages` (`id_session`) USING BTREE,
  KEY `FK_session_messages_users_core_user` (`id_user`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipo_produto`
--

DROP TABLE IF EXISTS `tipo_produto`;
CREATE TABLE IF NOT EXISTS `tipo_produto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `tipo_produto`
--

INSERT INTO `tipo_produto` (`id`, `descricao`) VALUES
(1, 'Merchandising'),
(2, 'Bilhete'),
(3, 'Evento');

-- --------------------------------------------------------

--
-- Estrutura da tabela `vendas`
--

DROP TABLE IF EXISTS `vendas`;
CREATE TABLE IF NOT EXISTS `vendas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_venda` int(11) DEFAULT NULL,
  `id_produto` int(11) DEFAULT NULL,
  `id_cidade` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `DataHora` datetime NOT NULL,
  `Quantidade` int(11) NOT NULL DEFAULT 0,
  `Receita` double NOT NULL,
  `canal_venda` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_vendas_id_venda` (`id_venda`),
  KEY `idx_vendas_id_produto` (`id_produto`),
  KEY `idx_vendas_id_cidade` (`id_cidade`),
  KEY `idx_vendas_id_categoria` (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=11762 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `vendas`
--

INSERT INTO `vendas` (`id`, `id_venda`, `id_produto`, `id_cidade`, `id_categoria`, `DataHora`, `Quantidade`, `Receita`, `canal_venda`) VALUES
(10781, 1122, 81, 1, 1, '2025-02-09 21:28:00', 1, 12, 'Loja Física'),
(10782, 1129, 82, 1, 1, '2025-01-31 17:08:00', 1, 12, 'Bilheteira'),
(10783, 1213, 82, 2, 1, '2025-01-21 16:26:00', 1, 12, 'Bilheteira'),
(10784, 1371, 83, 1, 1, '2025-01-26 19:28:00', 1, 12, 'Online'),
(10785, 1390, 83, 3, 1, '2025-02-19 16:46:00', 1, 12, 'Online'),
(10786, 1396, 81, 4, 1, '2025-02-20 18:35:00', 1, 12, 'Online'),
(10787, 1447, 81, 3, 1, '2025-03-27 10:58:00', 1, 12, 'Loja Física'),
(10788, 1449, 82, 1, 1, '2025-04-15 11:55:00', 1, 12, 'Bilheteira'),
(10789, 1450, 82, 2, 1, '2025-04-19 21:56:00', 1, 12, 'Online'),
(10790, 1504, 83, 5, 1, '2025-04-19 17:40:00', 1, 12, 'Loja Física'),
(10791, 1651, 84, 1, 1, '2025-01-14 15:11:00', 1, 12, 'Loja Física'),
(10792, 1713, 83, 3, 1, '2025-01-02 15:06:00', 1, 12, 'Online'),
(10793, 1756, 82, 1, 1, '2025-02-19 20:21:00', 1, 12, 'Online'),
(10794, 1805, 84, 3, 1, '2025-02-11 16:07:00', 1, 12, 'Bilheteira'),
(10795, 1815, 84, 3, 1, '2025-02-25 10:24:00', 1, 12, 'Bilheteira'),
(10796, 1848, 82, 2, 1, '2025-03-24 19:11:00', 1, 12, 'Bilheteira'),
(10797, 1883, 83, 3, 1, '2025-04-05 19:29:00', 1, 12, 'Online'),
(10798, 1937, 83, 1, 1, '2025-03-11 11:18:00', 1, 12, 'Online'),
(10799, 1945, 81, 3, 1, '2025-04-30 16:17:00', 1, 12, 'Bilheteira'),
(10800, 1001, 85, 6, 2, '2025-01-12 12:14:00', 1, 15, 'Loja Física'),
(10801, 1021, 86, 1, 2, '2025-04-21 14:04:00', 1, 15, 'Online'),
(10802, 1211, 87, 2, 2, '2025-03-24 21:36:00', 1, 15, 'Loja Física'),
(10803, 1302, 88, 2, 2, '2025-04-09 12:42:00', 1, 15, 'Bilheteira'),
(10804, 1442, 87, 6, 2, '2025-03-30 10:26:00', 1, 15, 'Bilheteira'),
(10805, 1461, 85, 6, 2, '2025-02-21 15:02:00', 1, 15, 'Loja Física'),
(10806, 1488, 86, 3, 2, '2025-01-27 19:40:00', 1, 15, 'Desconhecido'),
(10807, 1490, 87, 5, 2, '2025-01-23 21:16:00', 1, 15, 'Online'),
(10808, 1564, 85, 3, 2, '2025-02-03 18:09:00', 1, 15, 'Loja Física'),
(10809, 1676, 85, 2, 2, '2025-02-19 09:05:00', 1, 15, 'Bilheteira'),
(10810, 1752, 85, 3, 2, '2025-03-02 20:49:00', 1, 15, 'Online'),
(10811, 1836, 85, 6, 2, '2025-04-21 10:20:00', 1, 15, 'Bilheteira'),
(10812, 1928, 88, 3, 2, '2025-02-23 16:36:00', 1, 15, 'Loja Física'),
(10813, 1191, 89, 1, 2, '2025-04-12 12:56:00', 1, 18, 'Bilheteira'),
(10814, 1055, 90, 3, 3, '2025-02-01 16:39:00', 1, 18, 'Bilheteira'),
(10815, 1085, 91, 3, 3, '2025-03-12 13:44:00', 1, 18, 'Loja Física'),
(10816, 1223, 92, 5, 3, '2025-01-05 11:45:00', 1, 18, 'Bilheteira'),
(10817, 1258, 93, 6, 2, '2025-01-13 18:02:00', 1, 18, 'Loja Física'),
(10818, 1278, 94, 2, 2, '2025-04-28 10:33:00', 1, 18, 'Online'),
(10819, 1280, 91, 3, 3, '2025-01-12 15:24:00', 1, 18, 'Loja Física'),
(10820, 1281, 95, 5, 2, '2025-03-05 22:27:00', 1, 18, 'Bilheteira'),
(10821, 1344, 92, 6, 3, '2025-03-17 10:00:00', 1, 18, 'Online'),
(10822, 1349, 95, 1, 2, '2025-01-21 16:22:00', 1, 18, 'Loja Física'),
(10823, 1392, 92, 6, 3, '2025-02-07 09:20:00', 1, 18, 'Online'),
(10824, 1448, 96, 1, 3, '2025-04-26 13:41:00', 1, 18, 'Bilheteira'),
(10825, 1535, 89, 3, 2, '2025-01-21 10:17:00', 1, 18, 'Bilheteira'),
(10826, 1715, 96, 5, 3, '2025-04-20 18:08:00', 1, 18, 'Loja Física'),
(10827, 1736, 94, 2, 2, '2025-04-23 16:05:00', 1, 18, 'Online'),
(10828, 1743, 93, 3, 2, '2025-03-04 17:07:00', 1, 18, 'Online'),
(10829, 1748, 89, 1, 2, '2025-04-20 16:29:00', 1, 18, 'Online'),
(10830, 1795, 91, 2, 3, '2025-01-29 11:54:00', 1, 18, 'Online'),
(10831, 1822, 89, 3, 2, '2025-03-10 14:02:00', 1, 18, 'Loja Física'),
(10832, 1866, 93, 2, 2, '2025-01-30 11:02:00', 1, 18, 'Bilheteira'),
(10833, 1900, 90, 2, 3, '2025-02-15 13:22:00', 1, 18, 'Desconhecido'),
(10834, 1934, 92, 2, 3, '2025-03-26 17:11:00', 1, 18, 'Bilheteira'),
(10835, 1942, 94, 2, 2, '2025-02-04 17:37:00', 1, 18, 'Online'),
(10836, 1993, 89, 2, 2, '2025-01-16 10:23:00', 1, 18, 'Loja Física'),
(10837, 1005, 97, 2, 1, '2025-01-06 19:14:00', 1, 22, 'Online'),
(10838, 1024, 98, 2, 2, '2025-02-01 12:12:00', 1, 22, 'Bilheteira'),
(10839, 1054, 99, 2, 2, '2025-04-15 21:15:00', 1, 22, 'Bilheteira'),
(10840, 1071, 100, 3, 2, '2025-03-16 09:59:00', 1, 22, 'Loja Física'),
(10841, 1076, 97, 5, 1, '2025-02-05 16:15:00', 1, 22, 'Loja Física'),
(10842, 1110, 100, 3, 2, '2025-04-22 22:28:00', 1, 22, 'Loja Física'),
(10843, 1172, 98, 3, 2, '2025-02-16 13:11:00', 1, 22, 'Bilheteira'),
(10844, 1226, 98, 5, 2, '2025-03-18 16:16:00', 1, 22, 'Loja Física'),
(10845, 1251, 98, 2, 2, '2025-02-20 13:52:00', 1, 22, 'Loja Física'),
(10846, 1290, 101, 5, 1, '2025-01-24 15:28:00', 1, 22, 'Loja Física'),
(10847, 1314, 100, 2, 2, '2025-01-31 13:07:00', 1, 22, 'Bilheteira'),
(10848, 1361, 100, 1, 2, '2025-01-06 12:57:00', 1, 22, 'Bilheteira'),
(10849, 1414, 101, 5, 1, '2025-02-09 20:32:00', 1, 22, 'Online'),
(10850, 1479, 102, 3, 1, '2025-01-24 11:47:00', 1, 22, 'Online'),
(10851, 1481, 102, 4, 1, '2025-01-20 14:38:00', 1, 22, 'Loja Física'),
(10852, 1542, 98, 2, 2, '2025-03-12 11:30:00', 1, 22, 'Bilheteira'),
(10853, 1620, 102, 6, 1, '2025-02-18 18:57:00', 1, 22, 'Loja Física'),
(10854, 1670, 103, 3, 2, '2025-03-29 22:38:00', 1, 22, 'Bilheteira'),
(10855, 1671, 103, 1, 2, '2025-03-15 21:19:00', 1, 22, 'Online'),
(10856, 1720, 98, 1, 2, '2025-01-05 10:04:00', 1, 22, 'Loja Física'),
(10857, 1827, 99, 2, 2, '2025-03-14 21:33:00', 1, 22, 'Bilheteira'),
(10858, 1851, 97, 5, 1, '2025-02-23 14:11:00', 1, 22, 'Bilheteira'),
(10859, 1953, 97, 2, 3, '2025-04-15 18:40:00', 1, 22, 'Loja Física'),
(10860, 1965, 98, 1, 2, '2025-04-11 11:03:00', 1, 22, 'Online'),
(10861, 1820, 104, 6, 2, '2025-02-24 14:22:00', 1, 25, 'Bilheteira'),
(10862, 1016, 104, 6, 2, '2025-01-15 14:56:00', 1, 25, 'Online'),
(10863, 1074, 105, 2, 2, '2025-02-25 14:40:00', 1, 25, 'Loja Física'),
(10864, 1139, 105, 6, 2, '2025-04-26 10:20:00', 1, 25, 'Online'),
(10865, 1198, 106, 1, 2, '2025-01-17 10:15:00', 1, 25, 'Bilheteira'),
(10866, 1202, 107, 6, 3, '2025-02-27 11:57:00', 1, 25, 'Bilheteira'),
(10867, 1277, 108, 1, 2, '2025-01-03 17:46:00', 1, 25, 'Loja Física'),
(10868, 1331, 108, 6, 2, '2025-01-16 22:10:00', 1, 25, 'Bilheteira'),
(10869, 1372, 108, 3, 2, '2025-01-22 18:27:00', 1, 25, 'Bilheteira'),
(10870, 1389, 104, 1, 2, '2025-02-03 12:15:00', 1, 25, 'Online'),
(10871, 1489, 106, 1, 2, '2025-04-06 19:09:00', 1, 25, 'Bilheteira'),
(10872, 1531, 106, 5, 2, '2025-04-13 10:52:00', 1, 25, 'Bilheteira'),
(10873, 1646, 109, 1, 3, '2025-02-23 13:19:00', 1, 25, 'Bilheteira'),
(10874, 1657, 110, 2, 3, '2025-01-16 09:29:00', 1, 25, 'Online'),
(10875, 1703, 104, 2, 2, '2025-01-17 17:04:00', 1, 25, 'Desconhecido'),
(10876, 1838, 104, 5, 2, '2025-01-31 18:07:00', 1, 25, 'Bilheteira'),
(10877, 1853, 110, 2, 3, '2025-02-21 18:27:00', 1, 25, 'Bilheteira'),
(10878, 1870, 106, 6, 2, '2025-04-24 14:01:00', 1, 25, 'Loja Física'),
(10879, 1882, 105, 1, 2, '2025-03-01 19:46:00', 1, 25, 'Bilheteira'),
(10880, 1956, 109, 1, 3, '2025-03-17 11:47:00', 1, 25, 'Online'),
(10881, 1957, 110, 5, 3, '2025-03-30 19:34:00', 1, 25, 'Bilheteira'),
(10882, 1088, 111, 5, 3, '2025-02-01 10:35:00', 1, 29, 'Loja Física'),
(10883, 1187, 112, 6, 3, '2025-03-09 17:32:00', 1, 29, 'Loja Física'),
(10884, 1472, 111, 5, 3, '2025-04-08 14:35:00', 1, 29, 'Loja Física'),
(10885, 1495, 113, 6, 3, '2025-03-12 22:35:00', 1, 29, 'Online'),
(10886, 1618, 111, 3, 3, '2025-02-13 20:51:00', 1, 29, 'Bilheteira'),
(10887, 1652, 114, 3, 3, '2025-01-12 21:19:00', 1, 29, 'Bilheteira'),
(10888, 1659, 113, 6, 3, '2025-02-09 13:32:00', 1, 29, 'Bilheteira'),
(10889, 1826, 113, 6, 3, '2025-02-08 18:25:00', 1, 29, 'Loja Física'),
(10890, 1954, 114, 5, 3, '2025-02-05 16:57:00', 1, 29, 'Loja Física'),
(10891, 1004, 115, 6, 1, '2025-04-04 16:34:00', 1, 35, 'Bilheteira'),
(10892, 1009, 116, 4, 1, '2025-01-28 18:56:00', 1, 35, 'Bilheteira'),
(10893, 1035, 117, 3, 1, '2025-04-23 12:23:00', 1, 35, 'Online'),
(10894, 1036, 118, 5, 1, '2025-05-01 11:16:00', 1, 35, 'Online'),
(10895, 1120, 115, 5, 1, '2025-04-17 19:25:00', 1, 35, 'Online'),
(10896, 1136, 117, 3, 1, '2025-01-23 13:03:00', 1, 35, 'Loja Física'),
(10897, 1155, 115, 4, 1, '2025-01-01 16:47:00', 1, 35, 'Online'),
(10898, 1220, 116, 1, 1, '2025-02-21 09:36:00', 1, 35, 'Online'),
(10899, 1383, 117, 6, 1, '2025-01-03 11:37:00', 1, 35, 'Online'),
(10900, 1482, 116, 2, 1, '2025-04-11 20:20:00', 1, 35, 'Online'),
(10901, 1691, 118, 1, 1, '2025-01-31 15:44:00', 1, 35, 'Bilheteira'),
(10902, 1704, 115, 2, 1, '2025-04-05 10:38:00', 1, 35, 'Loja Física'),
(10903, 1762, 116, 2, 1, '2025-01-25 16:05:00', 1, 35, 'Bilheteira'),
(10904, 1781, 116, 6, 1, '2025-04-30 18:48:00', 1, 35, 'Online'),
(10905, 1819, 115, 1, 1, '2025-01-04 18:02:00', 1, 35, 'Bilheteira'),
(10906, 1946, 117, 1, 1, '2025-01-21 20:34:00', 1, 35, 'Online'),
(10907, 1068, 119, 6, 1, '2025-04-06 17:03:00', 1, 40, 'Online'),
(10908, 1126, 119, 1, 1, '2025-02-03 17:07:00', 1, 40, 'Bilheteira'),
(10909, 1158, 119, 1, 1, '2025-02-11 11:51:00', 1, 40, 'Bilheteira'),
(10910, 1181, 120, 1, 1, '2025-02-17 12:01:00', 1, 40, 'Online'),
(10911, 1312, 120, 1, 1, '2025-02-03 19:55:00', 1, 40, 'Loja Física'),
(10912, 1397, 119, 3, 1, '2025-02-07 22:42:00', 1, 40, 'Loja Física'),
(10913, 1487, 121, 6, 1, '2025-02-07 19:12:00', 1, 40, 'Loja Física'),
(10914, 1607, 119, 3, 1, '2025-04-10 09:58:00', 1, 40, 'Bilheteira'),
(10915, 1824, 119, 5, 1, '2025-03-30 19:13:00', 1, 40, 'Bilheteira'),
(10916, 1895, 121, 3, 1, '2025-03-05 18:41:00', 1, 40, 'Bilheteira'),
(10917, 1905, 121, 6, 1, '2025-01-20 19:23:00', 1, 40, 'Online'),
(10918, 1982, 120, 2, 1, '2025-01-16 11:56:00', 1, 40, 'Online'),
(10919, 1229, 122, 1, 3, '2025-04-01 11:33:00', 1, 49, 'Loja Física'),
(10920, 1284, 123, 3, 3, '2025-02-08 11:36:00', 1, 49, 'Loja Física'),
(10921, 1369, 124, 6, 3, '2025-04-13 21:08:00', 1, 49, 'Online'),
(10922, 1563, 123, 6, 3, '2025-01-13 10:59:00', 1, 49, 'Loja Física'),
(10923, 1641, 122, 5, 3, '2025-04-03 17:07:00', 1, 49, 'Loja Física'),
(10924, 1645, 122, 2, 3, '2025-04-09 11:58:00', 1, 49, 'Loja Física'),
(10925, 1726, 125, 3, 3, '2025-03-22 20:22:00', 1, 49, 'Online'),
(10926, 1858, 125, 3, 3, '2025-01-02 16:08:00', 1, 49, 'Loja Física'),
(10927, 1906, 122, 1, 3, '2025-02-01 22:51:00', 1, 49, 'Bilheteira'),
(10928, 1920, 122, 2, 3, '2025-01-12 09:27:00', 1, 49, 'Desconhecido'),
(10929, 1964, 124, 6, 3, '2025-03-22 16:37:00', 1, 49, 'Online'),
(10930, 1038, 126, 6, 4, '2025-03-23 15:53:00', 1, 50, 'Online'),
(10931, 1183, 127, 5, 4, '2025-02-02 12:53:00', 1, 50, 'Loja Física'),
(10932, 1197, 126, 2, 4, '2025-03-27 19:25:00', 1, 50, 'Loja Física'),
(10933, 1291, 127, 1, 4, '2025-02-15 17:05:00', 1, 50, 'Loja Física'),
(10934, 1327, 128, 1, 4, '2025-02-21 17:47:00', 1, 50, 'Loja Física'),
(10935, 1334, 127, 2, 4, '2025-01-28 16:04:00', 1, 50, 'Loja Física'),
(10936, 1375, 128, 5, 4, '2025-02-05 15:08:00', 1, 50, 'Online'),
(10937, 1536, 129, 5, 4, '2025-04-28 10:35:00', 1, 50, 'Loja Física'),
(10938, 1583, 129, 5, 4, '2025-03-16 21:44:00', 1, 50, 'Loja Física'),
(10939, 1732, 129, 4, 4, '2025-01-15 16:38:00', 1, 50, 'Online'),
(10940, 1816, 128, 2, 4, '2025-01-23 17:42:00', 1, 50, 'Loja Física'),
(10941, 1966, 127, 6, 4, '2025-03-13 09:18:00', 1, 50, 'Bilheteira'),
(10942, 1241, 130, 1, 4, '2025-02-12 11:46:00', 1, 60, 'Loja Física'),
(10943, 1339, 131, 3, 4, '2025-04-25 10:08:00', 1, 60, 'Loja Física'),
(10944, 1516, 132, 4, 4, '2025-01-17 18:37:00', 1, 60, 'Online'),
(10945, 1525, 130, 5, 4, '2025-04-01 20:50:00', 1, 60, 'Loja Física'),
(10946, 1730, 133, 6, 4, '2025-01-05 20:09:00', 1, 60, 'Loja Física'),
(10947, 1757, 130, 1, 4, '2025-03-21 14:47:00', 1, 60, 'Loja Física'),
(10948, 1784, 131, 3, 4, '2025-04-12 09:09:00', 1, 60, 'Bilheteira'),
(10949, 1807, 130, 3, 4, '2025-03-28 16:43:00', 1, 60, 'Bilheteira'),
(10950, 1192, 134, 6, 4, '2025-04-07 19:12:00', 1, 70, 'Bilheteira'),
(10951, 1114, 135, 1, 4, '2025-01-06 14:50:00', 1, 70, 'Bilheteira'),
(10952, 1156, 135, 6, 4, '2025-02-20 22:47:00', 1, 70, 'Bilheteira'),
(10953, 1243, 134, 3, 4, '2025-02-21 19:06:00', 1, 70, 'Online'),
(10954, 1594, 134, 6, 4, '2025-02-16 12:38:00', 1, 70, 'Online'),
(10955, 1832, 134, 1, 4, '2025-03-23 12:54:00', 1, 70, 'Bilheteira'),
(10956, 1892, 136, 3, 4, '2025-01-14 19:54:00', 1, 70, 'Bilheteira'),
(10957, 1941, 136, 3, 4, '2025-02-10 16:35:00', 1, 70, 'Online'),
(10958, 1145, 137, 5, 4, '2025-02-06 18:19:00', 1, 80, 'Online'),
(10959, 1130, 138, 6, 4, '2025-04-17 16:39:00', 1, 80, 'Bilheteira'),
(10960, 1250, 139, 5, 4, '2025-02-28 11:32:00', 1, 80, 'Bilheteira'),
(10961, 1465, 138, 3, 4, '2025-02-02 18:12:00', 1, 80, 'Online'),
(10962, 1473, 137, 6, 4, '2025-03-08 10:01:00', 1, 80, 'Online'),
(10963, 1540, 139, 2, 4, '2025-02-03 10:24:00', 1, 80, 'Online'),
(10964, 1577, 137, 1, 4, '2025-02-12 10:53:00', 1, 80, 'Online'),
(10965, 1602, 140, 5, 4, '2025-04-03 09:18:00', 1, 80, 'Online'),
(10966, 1649, 140, 1, 4, '2025-03-18 18:00:00', 1, 80, 'Loja Física'),
(10967, 1891, 140, 1, 4, '2025-04-21 16:37:00', 1, 80, 'Online'),
(10968, 1958, 139, 6, 4, '2025-04-20 14:27:00', 1, 80, 'Bilheteira'),
(10969, 1204, 81, 1, 1, '2025-04-12 11:15:00', 2, 24, 'Online'),
(10970, 1763, 83, 2, 1, '2025-02-05 10:44:00', 2, 24, 'Bilheteira'),
(10971, 1779, 82, 1, 1, '2025-04-04 16:47:00', 2, 24, 'Bilheteira'),
(10972, 1040, 87, 5, 2, '2025-03-11 09:53:00', 2, 30, 'Loja Física'),
(10973, 1097, 88, 2, 2, '2025-03-02 17:41:00', 2, 30, 'Bilheteira'),
(10974, 1104, 85, 1, 2, '2025-03-05 20:18:00', 2, 30, 'Loja Física'),
(10975, 1125, 85, 3, 2, '2025-04-07 12:55:00', 2, 30, 'Loja Física'),
(10976, 1148, 88, 1, 2, '2025-02-04 20:48:00', 2, 30, 'Bilheteira'),
(10977, 1159, 85, 3, 2, '2025-02-25 18:25:00', 2, 30, 'Online'),
(10978, 1179, 88, 3, 2, '2025-02-04 16:57:00', 2, 30, 'Online'),
(10979, 1322, 85, 1, 2, '2025-01-27 21:47:00', 2, 30, 'Loja Física'),
(10980, 1517, 86, 5, 2, '2025-02-03 11:33:00', 2, 30, 'Loja Física'),
(10981, 1518, 88, 2, 2, '2025-02-27 18:30:00', 2, 30, 'Online'),
(10982, 1576, 86, 1, 2, '2025-01-02 16:13:00', 2, 30, 'Bilheteira'),
(10983, 1694, 87, 6, 2, '2025-04-03 16:42:00', 2, 30, 'Online'),
(10984, 1706, 88, 3, 2, '2025-03-18 22:09:00', 2, 30, 'Bilheteira'),
(10985, 1813, 85, 1, 2, '2025-02-18 18:43:00', 2, 30, 'Online'),
(10986, 1904, 87, 2, 2, '2025-03-22 10:55:00', 2, 30, 'Bilheteira'),
(10987, 1947, 85, 5, 2, '2025-04-03 17:17:00', 2, 30, 'Online'),
(10988, 1069, 95, 2, 2, '2025-04-18 09:39:00', 2, 36, 'Online'),
(10989, 1090, 95, 2, 2, '2025-02-03 19:05:00', 2, 36, 'Online'),
(10990, 1151, 95, 1, 2, '2025-04-07 18:03:00', 2, 36, 'Online'),
(10991, 1210, 93, 5, 2, '2025-03-26 18:46:00', 2, 36, 'Bilheteira'),
(10992, 1228, 96, 3, 3, '2025-01-03 16:20:00', 2, 36, 'Online'),
(10993, 1275, 94, 5, 2, '2025-01-09 20:09:00', 2, 36, 'Online'),
(10994, 1282, 95, 1, 2, '2025-04-26 22:44:00', 2, 36, 'Bilheteira'),
(10995, 1321, 92, 1, 3, '2025-02-08 22:02:00', 2, 36, 'Bilheteira'),
(10996, 1363, 94, 1, 2, '2025-02-07 13:54:00', 2, 36, 'Bilheteira'),
(10997, 1398, 96, 6, 3, '2025-01-22 19:18:00', 2, 36, 'Bilheteira'),
(10998, 1415, 93, 6, 2, '2025-04-18 09:15:00', 2, 36, 'Bilheteira'),
(10999, 1421, 90, 1, 3, '2025-02-02 18:51:00', 2, 36, 'Loja Física'),
(11000, 1429, 91, 1, 3, '2025-02-15 12:47:00', 2, 36, 'Bilheteira'),
(11001, 1440, 93, 2, 2, '2025-01-28 20:01:00', 2, 36, 'Loja Física'),
(11002, 1553, 92, 5, 3, '2025-02-23 16:08:00', 2, 36, 'Loja Física'),
(11003, 1575, 96, 3, 3, '2025-01-14 13:17:00', 2, 36, 'Loja Física'),
(11004, 1584, 91, 1, 3, '2025-01-21 16:05:00', 2, 36, 'Loja Física'),
(11005, 1593, 90, 5, 3, '2025-01-14 16:12:00', 2, 36, 'Online'),
(11006, 1627, 89, 3, 2, '2025-02-13 15:42:00', 2, 36, 'Online'),
(11007, 1636, 90, 1, 3, '2025-04-29 16:55:00', 2, 36, 'Bilheteira'),
(11008, 1668, 94, 1, 2, '2025-02-13 16:46:00', 2, 36, 'Bilheteira'),
(11009, 1727, 90, 3, 3, '2025-01-04 20:37:00', 2, 36, 'Desconhecido'),
(11010, 1746, 94, 1, 2, '2025-04-29 18:29:00', 2, 36, 'Bilheteira'),
(11011, 1799, 93, 1, 2, '2025-03-27 14:01:00', 2, 36, 'Online'),
(11012, 1803, 92, 5, 3, '2025-04-17 14:24:00', 2, 36, 'Online'),
(11013, 1000, 103, 5, 2, '2025-01-29 11:47:00', 2, 44, 'Loja Física'),
(11014, 1003, 97, 6, 1, '2025-04-08 14:06:00', 2, 44, 'Bilheteira'),
(11015, 1047, 103, 3, 2, '2025-03-16 13:02:00', 2, 44, 'Loja Física'),
(11016, 1061, 101, 2, 1, '2025-01-30 15:44:00', 2, 44, 'Loja Física'),
(11017, 1084, 100, 5, 2, '2025-02-16 11:19:00', 2, 44, 'Loja Física'),
(11018, 1115, 102, 2, 1, '2025-03-09 15:36:00', 2, 44, 'Online'),
(11019, 1133, 103, 5, 2, '2025-01-17 21:36:00', 2, 44, 'Desconhecido'),
(11020, 1207, 141, 5, 1, '2025-02-25 17:58:00', 2, 44, 'Online'),
(11021, 1245, 99, 2, 2, '2025-01-08 19:07:00', 2, 44, 'Bilheteira'),
(11022, 1308, 101, 5, 1, '2025-03-08 11:35:00', 2, 44, 'Bilheteira'),
(11023, 1367, 100, 5, 2, '2025-01-12 20:15:00', 2, 44, 'Bilheteira'),
(11024, 1368, 99, 5, 2, '2025-01-04 15:54:00', 2, 44, 'Loja Física'),
(11025, 1410, 98, 6, 2, '2025-01-07 20:30:00', 2, 44, 'Bilheteira'),
(11026, 1425, 97, 3, 1, '2025-03-08 21:15:00', 2, 44, 'Loja Física'),
(11027, 1427, 100, 1, 2, '2025-03-29 17:40:00', 2, 44, 'Loja Física'),
(11028, 1434, 98, 3, 2, '2025-04-08 21:10:00', 2, 44, 'Online'),
(11029, 1443, 102, 3, 1, '2025-03-30 19:40:00', 2, 44, 'Bilheteira'),
(11030, 1471, 97, 1, 1, '2025-01-27 18:45:00', 2, 44, 'Loja Física'),
(11031, 1474, 100, 1, 2, '2025-02-06 19:16:00', 2, 44, 'Online'),
(11032, 1514, 141, 2, 1, '2025-01-21 14:38:00', 2, 44, 'Online'),
(11033, 1585, 103, 3, 2, '2025-03-31 17:50:00', 2, 44, 'Online'),
(11034, 1631, 100, 3, 2, '2025-04-04 09:48:00', 2, 44, 'Bilheteira'),
(11035, 1633, 141, 3, 1, '2025-03-29 09:22:00', 2, 44, 'Loja Física'),
(11036, 1769, 141, 5, 1, '2025-01-21 12:07:00', 2, 44, 'Bilheteira'),
(11037, 1796, 141, 6, 1, '2025-01-11 15:44:00', 2, 44, 'Online'),
(11038, 1885, 97, 6, 1, '2025-01-24 10:47:00', 2, 44, 'Bilheteira'),
(11039, 1888, 101, 2, 1, '2025-01-02 12:07:00', 2, 44, 'Loja Física'),
(11040, 1896, 100, 2, 2, '2025-03-02 14:28:00', 2, 44, 'Loja Física'),
(11041, 1980, 141, 6, 1, '2025-01-03 11:53:00', 2, 44, 'Online'),
(11042, 1066, 108, 3, 2, '2025-04-21 16:11:00', 2, 50, 'Bilheteira'),
(11043, 1111, 106, 5, 2, '2025-01-10 16:50:00', 2, 50, 'Bilheteira'),
(11044, 1173, 109, 5, 3, '2025-01-10 13:54:00', 2, 50, 'Loja Física'),
(11045, 1208, 110, 1, 3, '2025-02-11 20:14:00', 2, 50, 'Loja Física'),
(11046, 1218, 105, 1, 2, '2025-01-28 18:22:00', 2, 50, 'Online'),
(11047, 1235, 107, 4, 3, '2025-01-07 19:57:00', 2, 50, 'Online'),
(11048, 1253, 104, 3, 2, '2025-04-09 11:49:00', 2, 50, 'Loja Física'),
(11049, 1413, 106, 5, 2, '2025-04-27 22:26:00', 2, 50, 'Bilheteira'),
(11050, 1508, 142, 4, 3, '2025-03-14 18:42:00', 2, 50, 'Loja Física'),
(11051, 1522, 108, 3, 2, '2025-04-26 18:34:00', 2, 50, 'Loja Física'),
(11052, 1526, 108, 6, 2, '2025-03-30 21:20:00', 2, 50, 'Bilheteira'),
(11053, 1530, 106, 5, 2, '2025-01-13 12:32:00', 2, 50, 'Bilheteira'),
(11054, 1544, 109, 6, 3, '2025-04-18 18:22:00', 2, 50, 'Online'),
(11055, 1562, 107, 6, 3, '2025-03-26 13:47:00', 2, 50, 'Loja Física'),
(11056, 1623, 104, 3, 2, '2025-02-18 17:45:00', 2, 50, 'Bilheteira'),
(11057, 1647, 107, 3, 3, '2025-01-01 18:48:00', 2, 50, 'Online'),
(11058, 1650, 107, 6, 3, '2025-01-08 19:22:00', 2, 50, 'Online'),
(11059, 1669, 107, 5, 3, '2025-04-03 09:29:00', 2, 50, 'Loja Física'),
(11060, 1707, 142, 1, 3, '2025-03-15 20:53:00', 2, 50, 'Desconhecido'),
(11061, 1785, 104, 6, 2, '2025-03-04 20:41:00', 2, 50, 'Online'),
(11062, 1830, 106, 5, 2, '2025-03-26 22:47:00', 2, 50, 'Bilheteira'),
(11063, 1879, 104, 5, 2, '2025-03-24 19:45:00', 2, 50, 'Bilheteira'),
(11064, 1889, 106, 2, 2, '2025-03-25 12:27:00', 2, 50, 'Loja Física'),
(11065, 1908, 142, 5, 3, '2025-04-13 15:26:00', 2, 50, 'Bilheteira'),
(11066, 1936, 104, 3, 2, '2025-02-23 09:55:00', 2, 50, 'Bilheteira'),
(11067, 1029, 111, 1, 3, '2025-01-08 18:47:00', 2, 58, 'Online'),
(11068, 1135, 111, 6, 3, '2025-01-15 19:55:00', 2, 58, 'Online'),
(11069, 1161, 113, 2, 3, '2025-01-31 10:09:00', 2, 58, 'Online'),
(11070, 1552, 112, 2, 3, '2025-03-13 15:54:00', 2, 58, 'Online'),
(11071, 1571, 112, 2, 3, '2025-02-22 17:27:00', 2, 58, 'Online'),
(11072, 1634, 114, 2, 3, '2025-04-20 15:31:00', 2, 58, 'Online'),
(11073, 1039, 117, 5, 1, '2025-04-05 16:35:00', 2, 70, 'Bilheteira'),
(11074, 1082, 115, 5, 3, '2025-01-16 20:12:00', 2, 70, 'Online'),
(11075, 1257, 117, 3, 1, '2025-04-30 20:48:00', 2, 70, 'Online'),
(11076, 1319, 118, 3, 1, '2025-03-10 13:10:00', 2, 70, 'Loja Física'),
(11077, 1333, 118, 2, 1, '2025-01-07 15:40:00', 2, 70, 'Desconhecido'),
(11078, 1340, 116, 5, 1, '2025-02-01 13:41:00', 2, 70, 'Online'),
(11079, 1341, 118, 4, 1, '2025-03-08 18:32:00', 2, 70, 'Loja Física'),
(11080, 1364, 116, 2, 1, '2025-01-10 12:08:00', 2, 70, 'Online'),
(11081, 1377, 116, 1, 1, '2025-01-04 14:38:00', 2, 70, 'Online'),
(11082, 1446, 116, 3, 1, '2025-01-06 17:31:00', 2, 70, 'Loja Física'),
(11083, 1537, 115, 6, 1, '2025-03-19 12:29:00', 2, 70, 'Loja Física'),
(11084, 1569, 116, 1, 1, '2025-02-08 09:00:00', 2, 70, 'Online'),
(11085, 1632, 116, 6, 1, '2025-04-10 12:06:00', 2, 70, 'Online'),
(11086, 1794, 115, 1, 1, '2025-04-15 16:56:00', 2, 70, 'Loja Física'),
(11087, 1975, 116, 2, 1, '2025-01-14 16:56:00', 2, 70, 'Bilheteira'),
(11088, 1196, 121, 1, 1, '2025-03-30 16:22:00', 2, 80, 'Online'),
(11089, 1287, 121, 5, 1, '2025-02-15 17:24:00', 2, 80, 'Desconhecido'),
(11090, 1317, 119, 3, 1, '2025-01-25 22:24:00', 2, 80, 'Loja Física'),
(11091, 1329, 119, 1, 1, '2025-02-24 22:13:00', 2, 80, 'Bilheteira'),
(11092, 1393, 120, 5, 1, '2025-04-04 10:35:00', 2, 80, 'Bilheteira'),
(11093, 1470, 143, 5, 1, '2025-01-18 15:38:00', 2, 80, 'Loja Física'),
(11094, 1812, 121, 6, 1, '2025-03-22 11:01:00', 2, 80, 'Loja Física'),
(11095, 1909, 119, 6, 1, '2025-04-09 09:45:00', 2, 80, 'Online'),
(11096, 1910, 143, 2, 1, '2025-02-25 09:25:00', 2, 80, 'Loja Física'),
(11097, 1146, 123, 6, 3, '2025-04-19 10:22:00', 2, 98, 'Bilheteira'),
(11098, 1227, 124, 2, 3, '2025-03-09 19:46:00', 2, 98, 'Bilheteira'),
(11099, 1267, 123, 2, 3, '2025-04-22 14:19:00', 2, 98, 'Online'),
(11100, 1354, 124, 1, 3, '2025-02-11 12:26:00', 2, 98, 'Bilheteira'),
(11101, 1404, 124, 6, 3, '2025-01-22 12:51:00', 2, 98, 'Online'),
(11102, 1579, 122, 6, 3, '2025-04-05 09:12:00', 2, 98, 'Loja Física'),
(11103, 1780, 122, 2, 3, '2025-04-17 18:38:00', 2, 98, 'Online'),
(11104, 1101, 128, 3, 4, '2025-03-08 14:39:00', 2, 100, 'Loja Física'),
(11105, 1127, 126, 5, 4, '2025-03-02 09:39:00', 2, 100, 'Bilheteira'),
(11106, 1206, 128, 5, 4, '2025-02-10 19:04:00', 2, 100, 'Bilheteira'),
(11107, 1409, 128, 3, 4, '2025-02-05 15:09:00', 2, 100, 'Loja Física'),
(11108, 1453, 129, 3, 4, '2025-03-31 20:03:00', 2, 100, 'Online'),
(11109, 1521, 129, 5, 4, '2025-03-02 18:38:00', 2, 100, 'Loja Física'),
(11110, 1533, 126, 5, 4, '2025-03-23 16:28:00', 2, 100, 'Online'),
(11111, 1797, 128, 5, 4, '2025-01-14 09:50:00', 2, 100, 'Loja Física'),
(11112, 1868, 128, 2, 4, '2025-01-16 14:05:00', 2, 100, 'Bilheteira'),
(11113, 1924, 128, 4, 4, '2025-05-01 17:23:00', 2, 100, 'Loja Física'),
(11114, 1940, 127, 3, 4, '2025-01-31 21:38:00', 2, 100, 'Online'),
(11115, 1949, 126, 6, 4, '2025-03-24 09:38:00', 2, 100, 'Online'),
(11116, 1271, 132, 3, 4, '2025-01-03 13:35:00', 2, 120, 'Loja Física'),
(11117, 1323, 133, 1, 4, '2025-04-15 12:51:00', 2, 120, 'Loja Física'),
(11118, 1432, 132, 2, 4, '2025-01-26 14:26:00', 2, 120, 'Bilheteira'),
(11119, 1497, 133, 6, 4, '2025-01-29 18:53:00', 2, 120, 'Online'),
(11120, 1679, 133, 2, 4, '2025-04-21 18:16:00', 2, 120, 'Bilheteira'),
(11121, 1684, 130, 5, 4, '2025-03-26 19:04:00', 2, 120, 'Loja Física'),
(11122, 1731, 132, 6, 4, '2025-01-02 11:40:00', 2, 120, 'Bilheteira'),
(11123, 1738, 131, 3, 4, '2025-03-20 20:02:00', 2, 120, 'Online'),
(11124, 1855, 132, 3, 4, '2025-01-25 22:52:00', 2, 120, 'Bilheteira'),
(11125, 1970, 131, 1, 4, '2025-01-18 21:02:00', 2, 120, 'Online'),
(11126, 1045, 144, 1, 4, '2025-01-29 09:42:00', 2, 140, 'Bilheteira'),
(11127, 1108, 134, 3, 4, '2025-03-31 12:36:00', 2, 140, 'Online'),
(11128, 1184, 136, 5, 4, '2025-02-08 10:03:00', 2, 140, 'Bilheteira'),
(11129, 1230, 134, 1, 4, '2025-02-28 17:21:00', 2, 140, 'Bilheteira'),
(11130, 1233, 134, 1, 4, '2025-02-07 09:18:00', 2, 140, 'Online'),
(11131, 1288, 136, 3, 4, '2025-04-02 10:05:00', 2, 140, 'Online'),
(11132, 1357, 136, 5, 4, '2025-02-07 18:50:00', 2, 140, 'Loja Física'),
(11133, 1619, 136, 5, 4, '2025-04-05 17:13:00', 2, 140, 'Loja Física'),
(11134, 1914, 135, 1, 4, '2025-01-12 17:35:00', 2, 140, 'Loja Física'),
(11135, 1010, 140, 5, 4, '2025-02-03 11:15:00', 2, 160, 'Loja Física'),
(11136, 1105, 140, 5, 4, '2025-02-28 17:09:00', 2, 160, 'Online'),
(11137, 1234, 137, 4, 4, '2025-01-26 22:34:00', 2, 160, 'Loja Física'),
(11138, 1394, 139, 1, 4, '2025-03-19 15:10:00', 2, 160, 'Online'),
(11139, 1405, 139, 1, 4, '2025-04-16 19:09:00', 2, 160, 'Bilheteira'),
(11140, 1546, 137, 5, 4, '2025-04-08 17:17:00', 2, 160, 'Online'),
(11141, 1578, 139, 6, 4, '2025-01-25 22:16:00', 2, 160, 'Online'),
(11142, 1611, 137, 6, 4, '2025-01-17 14:05:00', 2, 160, 'Loja Física'),
(11143, 1666, 139, 5, 4, '2025-02-17 16:53:00', 2, 160, 'Desconhecido'),
(11144, 1721, 139, 3, 4, '2025-03-25 19:00:00', 2, 160, 'Loja Física'),
(11145, 1782, 137, 2, 4, '2025-03-13 16:45:00', 2, 160, 'Online'),
(11146, 1839, 138, 3, 4, '2025-01-19 10:11:00', 2, 160, 'Bilheteira'),
(11147, 1856, 138, 2, 4, '2025-03-18 12:52:00', 2, 160, 'Loja Física'),
(11148, 1857, 138, 3, 4, '2025-01-04 13:16:00', 2, 160, 'Loja Física'),
(11149, 1913, 137, 1, 4, '2025-04-23 13:05:00', 2, 160, 'Loja Física'),
(11150, 1977, 138, 1, 4, '2025-04-16 09:23:00', 2, 160, 'Online'),
(11151, 1050, 82, 1, 1, '2025-03-21 14:42:00', 3, 36, 'Loja Física'),
(11152, 1153, 82, 1, 1, '2025-03-28 19:37:00', 3, 36, 'Loja Física'),
(11153, 1193, 84, 1, 1, '2025-02-25 15:47:00', 3, 36, 'Bilheteira'),
(11154, 1244, 81, 1, 1, '2025-02-19 12:28:00', 3, 36, 'Bilheteira'),
(11155, 1347, 82, 2, 1, '2025-03-31 15:46:00', 3, 36, 'Desconhecido'),
(11156, 1621, 81, 6, 1, '2025-01-26 21:44:00', 3, 36, 'Bilheteira'),
(11157, 1667, 81, 3, 1, '2025-04-11 09:49:00', 3, 36, 'Online'),
(11158, 1787, 82, 2, 1, '2025-03-07 20:36:00', 3, 36, 'Bilheteira'),
(11159, 1835, 81, 2, 1, '2025-04-12 21:17:00', 3, 36, 'Loja Física'),
(11160, 1164, 88, 1, 2, '2025-03-01 16:02:00', 3, 45, 'Bilheteira'),
(11161, 1266, 86, 6, 2, '2025-02-18 19:38:00', 3, 45, 'Desconhecido'),
(11162, 1496, 85, 2, 2, '2025-01-27 20:47:00', 3, 45, 'Bilheteira'),
(11163, 1653, 85, 1, 2, '2025-03-02 11:07:00', 3, 45, 'Bilheteira'),
(11164, 1682, 88, 2, 2, '2025-03-10 16:25:00', 3, 45, 'Bilheteira'),
(11165, 1798, 85, 6, 2, '2025-01-06 10:19:00', 3, 45, 'Online'),
(11166, 1951, 85, 3, 2, '2025-04-15 15:52:00', 3, 45, 'Bilheteira'),
(11167, 1103, 93, 2, 2, '2025-03-12 09:35:00', 3, 54, 'Online'),
(11168, 1113, 95, 6, 2, '2025-01-30 20:05:00', 3, 54, 'Online'),
(11169, 1182, 90, 3, 3, '2025-04-28 22:30:00', 3, 54, 'Online'),
(11170, 1325, 92, 2, 3, '2025-04-21 19:08:00', 3, 54, 'Online'),
(11171, 1346, 91, 5, 3, '2025-01-11 17:58:00', 3, 54, 'Online'),
(11172, 1352, 94, 6, 2, '2025-01-21 13:49:00', 3, 54, 'Loja Física'),
(11173, 1388, 94, 2, 2, '2025-04-06 10:15:00', 3, 54, 'Bilheteira'),
(11174, 1436, 91, 6, 3, '2025-04-07 22:33:00', 3, 54, 'Online'),
(11175, 1438, 96, 5, 3, '2025-02-07 16:46:00', 3, 54, 'Loja Física'),
(11176, 1524, 94, 5, 2, '2025-03-03 21:14:00', 3, 54, 'Bilheteira'),
(11177, 1603, 91, 1, 3, '2025-01-29 12:54:00', 3, 54, 'Online'),
(11178, 1614, 90, 6, 3, '2025-04-10 15:20:00', 3, 54, 'Loja Física'),
(11179, 1617, 93, 6, 2, '2025-01-20 21:46:00', 3, 54, 'Online'),
(11180, 1690, 91, 5, 3, '2025-04-26 17:03:00', 3, 54, 'Loja Física'),
(11181, 1759, 93, 5, 2, '2025-01-31 17:07:00', 3, 54, 'Bilheteira'),
(11182, 1776, 93, 6, 2, '2025-01-26 09:05:00', 3, 54, 'Bilheteira'),
(11183, 1804, 92, 3, 3, '2025-01-16 16:07:00', 3, 54, 'Online'),
(11184, 1809, 89, 2, 2, '2025-01-26 18:54:00', 3, 54, 'Online'),
(11185, 1849, 94, 2, 2, '2025-02-10 18:05:00', 3, 54, 'Online'),
(11186, 1873, 90, 5, 3, '2025-02-11 21:03:00', 3, 54, 'Online'),
(11187, 1978, 95, 6, 2, '2025-02-26 12:40:00', 3, 54, 'Bilheteira'),
(11188, 1979, 93, 2, 2, '2025-01-23 12:56:00', 3, 54, 'Loja Física'),
(11189, 1981, 92, 1, 3, '2025-04-30 12:19:00', 3, 54, 'Online'),
(11190, 1992, 91, 5, 3, '2025-04-26 10:18:00', 3, 54, 'Loja Física'),
(11191, 1995, 91, 5, 3, '2025-02-06 22:22:00', 3, 54, 'Bilheteira'),
(11192, 1100, 99, 5, 2, '2025-01-15 21:25:00', 3, 66, 'Online'),
(11193, 1124, 97, 1, 1, '2025-04-27 22:30:00', 3, 66, 'Loja Física'),
(11194, 1160, 97, 6, 1, '2025-04-10 11:04:00', 3, 66, 'Loja Física'),
(11195, 1272, 141, 5, 1, '2025-01-30 15:36:00', 3, 66, 'Bilheteira'),
(11196, 1343, 103, 1, 2, '2025-01-17 15:55:00', 3, 66, 'Bilheteira'),
(11197, 1418, 97, 6, 1, '2025-04-06 22:44:00', 3, 66, 'Bilheteira'),
(11198, 1428, 141, 5, 1, '2025-01-13 16:08:00', 3, 66, 'Bilheteira'),
(11199, 1439, 102, 3, 1, '2025-04-26 16:22:00', 3, 66, 'Online'),
(11200, 1502, 97, 1, 1, '2025-04-23 16:29:00', 3, 66, 'Bilheteira'),
(11201, 1565, 141, 2, 1, '2025-02-26 19:08:00', 3, 66, 'Loja Física'),
(11202, 1566, 103, 5, 2, '2025-04-21 16:29:00', 3, 66, 'Bilheteira'),
(11203, 1673, 141, 6, 1, '2025-01-15 09:39:00', 3, 66, 'Loja Física'),
(11204, 1744, 102, 4, 1, '2025-01-30 21:07:00', 3, 66, 'Online'),
(11205, 1761, 103, 3, 2, '2025-02-27 16:32:00', 3, 66, 'Online'),
(11206, 1768, 101, 5, 1, '2025-02-06 16:10:00', 3, 66, 'Online'),
(11207, 1863, 102, 1, 1, '2025-01-15 14:02:00', 3, 66, 'Bilheteira'),
(11208, 1897, 102, 1, 1, '2025-04-03 20:24:00', 3, 66, 'Loja Física'),
(11209, 1916, 103, 6, 2, '2025-03-22 17:22:00', 3, 66, 'Online'),
(11210, 1999, 98, 5, 2, '2025-01-29 15:27:00', 3, 66, 'Bilheteira'),
(11211, 1023, 108, 6, 2, '2025-02-24 15:29:00', 3, 75, 'Online'),
(11212, 1033, 110, 4, 3, '2025-02-20 11:42:00', 3, 75, 'Bilheteira'),
(11213, 1062, 105, 3, 2, '2025-03-11 16:26:00', 3, 75, 'Online'),
(11214, 1064, 142, 3, 3, '2025-02-25 16:01:00', 3, 75, 'Bilheteira'),
(11215, 1134, 109, 1, 3, '2025-04-10 11:50:00', 3, 75, 'Desconhecido'),
(11216, 1180, 106, 5, 2, '2025-04-30 09:26:00', 3, 75, 'Bilheteira'),
(11217, 1236, 108, 6, 2, '2025-04-02 16:06:00', 3, 75, 'Online'),
(11218, 1249, 109, 2, 3, '2025-04-20 17:28:00', 3, 75, 'Loja Física'),
(11219, 1252, 108, 3, 2, '2025-03-31 10:34:00', 3, 75, 'Online'),
(11220, 1265, 142, 1, 3, '2025-01-27 14:41:00', 3, 75, 'Desconhecido'),
(11221, 1307, 105, 6, 2, '2025-01-09 13:02:00', 3, 75, 'Online'),
(11222, 1350, 110, 3, 3, '2025-04-04 10:49:00', 3, 75, 'Bilheteira'),
(11223, 1466, 142, 5, 3, '2025-01-14 21:26:00', 3, 75, 'Loja Física'),
(11224, 1555, 107, 1, 3, '2025-03-02 22:40:00', 3, 75, 'Bilheteira'),
(11225, 1560, 110, 5, 3, '2025-02-10 19:18:00', 3, 75, 'Bilheteira'),
(11226, 1574, 105, 6, 2, '2025-03-31 18:31:00', 3, 75, 'Bilheteira'),
(11227, 1581, 104, 2, 2, '2025-01-26 14:56:00', 3, 75, 'Loja Física'),
(11228, 1582, 106, 6, 2, '2025-01-02 11:50:00', 3, 75, 'Loja Física'),
(11229, 1589, 106, 6, 2, '2025-04-15 13:34:00', 3, 75, 'Bilheteira'),
(11230, 1615, 105, 6, 2, '2025-02-14 12:20:00', 3, 75, 'Loja Física'),
(11231, 1644, 108, 5, 2, '2025-01-11 17:45:00', 3, 75, 'Loja Física'),
(11232, 1716, 107, 3, 3, '2025-02-07 16:42:00', 3, 75, 'Loja Física'),
(11233, 1747, 142, 5, 3, '2025-02-04 12:21:00', 3, 75, 'Online'),
(11234, 1758, 108, 2, 2, '2025-03-01 18:02:00', 3, 75, 'Bilheteira'),
(11235, 1821, 109, 1, 3, '2025-03-17 10:58:00', 3, 75, 'Online'),
(11236, 1861, 104, 6, 2, '2025-02-20 19:23:00', 3, 75, 'Loja Física'),
(11237, 1884, 108, 3, 2, '2025-02-10 18:46:00', 3, 75, 'Loja Física'),
(11238, 1984, 110, 5, 3, '2025-02-01 09:40:00', 3, 75, 'Online'),
(11239, 1123, 112, 5, 3, '2025-04-06 15:11:00', 3, 87, 'Online'),
(11240, 1242, 112, 5, 3, '2025-03-14 19:48:00', 3, 87, 'Online'),
(11241, 1289, 114, 1, 3, '2025-01-14 10:00:00', 3, 87, 'Bilheteira'),
(11242, 1437, 111, 1, 3, '2025-01-17 10:24:00', 3, 87, 'Loja Física'),
(11243, 1499, 114, 1, 3, '2025-01-17 19:41:00', 3, 87, 'Online'),
(11244, 1527, 114, 5, 3, '2025-04-20 17:27:00', 3, 87, 'Bilheteira'),
(11245, 1588, 111, 2, 3, '2025-04-04 16:17:00', 3, 87, 'Loja Física'),
(11246, 1605, 111, 6, 3, '2025-01-12 18:25:00', 3, 87, 'Online'),
(11247, 1672, 111, 6, 3, '2025-03-10 14:49:00', 3, 87, 'Loja Física'),
(11248, 1674, 113, 2, 3, '2025-01-19 20:51:00', 3, 87, 'Loja Física'),
(11249, 1754, 111, 1, 3, '2025-01-31 19:05:00', 3, 87, 'Bilheteira'),
(11250, 1760, 111, 1, 3, '2025-04-25 13:32:00', 3, 87, 'Bilheteira'),
(11251, 1770, 114, 1, 3, '2025-01-24 12:35:00', 3, 87, 'Online'),
(11252, 1907, 112, 2, 3, '2025-04-02 21:26:00', 3, 87, 'Loja Física'),
(11253, 1918, 113, 2, 3, '2025-03-27 21:52:00', 3, 87, 'Loja Física'),
(11254, 1046, 118, 1, 1, '2025-03-24 17:25:00', 3, 105, 'Loja Física'),
(11255, 1200, 116, 3, 1, '2025-02-01 10:01:00', 3, 105, 'Online'),
(11256, 1214, 117, 1, 1, '2025-04-04 22:22:00', 3, 105, 'Online'),
(11257, 1240, 118, 2, 1, '2025-02-28 19:34:00', 3, 105, 'Bilheteira'),
(11258, 1324, 117, 6, 1, '2025-02-07 18:17:00', 3, 105, 'Loja Física'),
(11259, 1411, 115, 6, 1, '2025-04-18 16:54:00', 3, 105, 'Loja Física'),
(11260, 1416, 117, 6, 1, '2025-04-16 16:32:00', 3, 105, 'Loja Física'),
(11261, 1493, 118, 3, 1, '2025-03-19 10:18:00', 3, 105, 'Bilheteira'),
(11262, 1554, 116, 6, 1, '2025-03-13 22:36:00', 3, 105, 'Bilheteira'),
(11263, 1701, 116, 1, 1, '2025-02-07 11:02:00', 3, 105, 'Loja Física'),
(11264, 1714, 117, 6, 1, '2025-01-25 09:01:00', 3, 105, 'Online'),
(11265, 1717, 116, 3, 1, '2025-01-21 21:04:00', 3, 105, 'Online'),
(11266, 1825, 117, 5, 1, '2025-02-25 12:31:00', 3, 105, 'Online'),
(11267, 1843, 116, 2, 1, '2025-04-26 21:43:00', 3, 105, 'Desconhecido'),
(11268, 1864, 116, 1, 1, '2025-03-20 22:48:00', 3, 105, 'Loja Física'),
(11269, 1926, 115, 5, 1, '2025-03-04 09:50:00', 3, 105, 'Online'),
(11270, 1972, 115, 2, 1, '2025-01-02 17:37:00', 3, 105, 'Loja Física'),
(11271, 1994, 117, 2, 1, '2025-02-08 20:52:00', 3, 105, 'Bilheteira'),
(11272, 1011, 121, 6, 1, '2025-01-29 11:32:00', 3, 120, 'Online'),
(11273, 1067, 120, 3, 1, '2025-02-13 21:56:00', 3, 120, 'Bilheteira'),
(11274, 1132, 119, 2, 1, '2025-01-25 10:54:00', 3, 120, 'Desconhecido'),
(11275, 1360, 119, 3, 1, '2025-01-14 12:33:00', 3, 120, 'Bilheteira'),
(11276, 1592, 143, 6, 1, '2025-01-15 10:33:00', 3, 120, 'Online'),
(11277, 1689, 143, 3, 1, '2025-01-12 18:00:00', 3, 120, 'Loja Física'),
(11278, 1725, 119, 3, 1, '2025-03-24 12:11:00', 3, 120, 'Online'),
(11279, 1773, 143, 5, 1, '2025-05-01 21:36:00', 3, 120, 'Online'),
(11280, 1789, 143, 6, 1, '2025-01-07 13:18:00', 3, 120, 'Desconhecido'),
(11281, 1860, 120, 6, 1, '2025-03-19 19:51:00', 3, 120, 'Loja Física'),
(11282, 1876, 121, 6, 1, '2025-04-26 19:38:00', 3, 120, 'Bilheteira'),
(11283, 1881, 120, 5, 1, '2025-03-14 09:35:00', 3, 120, 'Online'),
(11284, 1960, 121, 5, 1, '2025-01-01 15:12:00', 3, 120, 'Online'),
(11285, 1118, 124, 1, 3, '2025-03-17 13:40:00', 3, 147, 'Loja Física'),
(11286, 1128, 124, 6, 3, '2025-03-25 15:07:00', 3, 147, 'Online'),
(11287, 1194, 122, 3, 3, '2025-04-29 21:33:00', 3, 147, 'Online'),
(11288, 1261, 123, 2, 3, '2025-02-05 09:35:00', 3, 147, 'Loja Física'),
(11289, 1298, 125, 5, 3, '2025-04-15 21:25:00', 3, 147, 'Online'),
(11290, 1316, 123, 6, 3, '2025-01-18 11:20:00', 3, 147, 'Loja Física'),
(11291, 1376, 124, 5, 3, '2025-03-03 17:50:00', 3, 147, 'Bilheteira'),
(11292, 1385, 122, 1, 3, '2025-01-23 20:35:00', 3, 147, 'Loja Física'),
(11293, 1386, 123, 6, 3, '2025-04-04 20:18:00', 3, 147, 'Online'),
(11294, 1580, 122, 6, 3, '2025-04-30 14:10:00', 3, 147, 'Loja Física'),
(11295, 1642, 122, 2, 3, '2025-02-27 09:11:00', 3, 147, 'Loja Física'),
(11296, 1829, 122, 2, 3, '2025-03-21 17:29:00', 3, 147, 'Loja Física'),
(11297, 1845, 123, 6, 3, '2025-04-23 21:49:00', 3, 147, 'Bilheteira'),
(11298, 1997, 122, 3, 3, '2025-04-12 10:20:00', 3, 147, 'Bilheteira'),
(11299, 1080, 127, 5, 4, '2025-01-29 15:44:00', 3, 150, 'Bilheteira'),
(11300, 1246, 126, 3, 4, '2025-02-17 18:14:00', 3, 150, 'Online'),
(11301, 1262, 128, 1, 4, '2025-05-01 19:42:00', 3, 150, 'Loja Física'),
(11302, 1313, 128, 1, 4, '2025-02-15 22:29:00', 3, 150, 'Online'),
(11303, 1335, 127, 2, 4, '2025-04-15 10:55:00', 3, 150, 'Loja Física'),
(11304, 1532, 127, 3, 4, '2025-01-29 14:05:00', 3, 150, 'Desconhecido'),
(11305, 1658, 128, 6, 4, '2025-02-14 17:51:00', 3, 150, 'Online'),
(11306, 1665, 129, 1, 4, '2025-04-01 22:20:00', 3, 150, 'Online'),
(11307, 1718, 126, 3, 4, '2025-04-15 13:11:00', 3, 150, 'Online'),
(11308, 1765, 128, 4, 4, '2025-01-25 10:01:00', 3, 150, 'Loja Física'),
(11309, 1871, 126, 3, 4, '2025-01-20 09:05:00', 3, 150, 'Loja Física'),
(11310, 1872, 126, 5, 4, '2025-01-06 19:39:00', 3, 150, 'Bilheteira'),
(11311, 1919, 129, 6, 4, '2025-03-08 18:12:00', 3, 150, 'Bilheteira'),
(11312, 1224, 133, 5, 4, '2025-04-30 18:20:00', 3, 180, 'Bilheteira'),
(11313, 1231, 133, 2, 4, '2025-03-13 13:14:00', 3, 180, 'Bilheteira'),
(11314, 1263, 131, 2, 4, '2025-02-18 11:48:00', 3, 180, 'Bilheteira'),
(11315, 1300, 131, 3, 4, '2025-01-31 13:42:00', 3, 180, 'Loja Física'),
(11316, 1332, 133, 1, 4, '2025-01-21 22:59:00', 3, 180, 'Online'),
(11317, 1401, 130, 6, 4, '2025-03-14 09:09:00', 3, 180, 'Loja Física'),
(11318, 1572, 131, 5, 4, '2025-01-11 15:40:00', 3, 180, 'Loja Física'),
(11319, 1705, 130, 5, 4, '2025-04-11 20:15:00', 3, 180, 'Online'),
(11320, 1767, 130, 1, 4, '2025-01-22 21:16:00', 3, 180, 'Bilheteira'),
(11321, 1817, 131, 3, 4, '2025-04-02 15:31:00', 3, 180, 'Loja Física'),
(11322, 1831, 132, 1, 4, '2025-03-01 11:15:00', 3, 180, 'Loja Física'),
(11323, 1841, 131, 3, 4, '2025-04-23 21:59:00', 3, 180, 'Bilheteira'),
(11324, 1898, 133, 2, 4, '2025-03-30 20:05:00', 3, 180, 'Bilheteira'),
(11325, 1930, 131, 3, 4, '2025-01-12 21:39:00', 3, 180, 'Desconhecido'),
(11326, 1201, 136, 3, 4, '2025-04-01 16:13:00', 3, 210, 'Bilheteira'),
(11327, 1549, 136, 1, 4, '2025-03-20 22:16:00', 3, 210, 'Loja Física'),
(11328, 1643, 136, 6, 4, '2025-03-30 19:58:00', 3, 210, 'Online'),
(11329, 1677, 144, 6, 4, '2025-04-15 12:45:00', 3, 210, 'Loja Física'),
(11330, 1681, 135, 4, 4, '2025-03-19 18:08:00', 3, 210, 'Online'),
(11331, 1711, 144, 5, 4, '2025-02-04 21:06:00', 3, 210, 'Loja Física'),
(11332, 1902, 144, 2, 4, '2025-04-09 09:49:00', 3, 210, 'Bilheteira'),
(11333, 1927, 136, 6, 4, '2025-01-28 11:52:00', 3, 210, 'Bilheteira'),
(11334, 1989, 135, 3, 4, '2025-03-12 10:08:00', 3, 210, 'Bilheteira'),
(11335, 1095, 137, 5, 4, '2025-03-06 17:31:00', 3, 240, 'Online'),
(11336, 1117, 137, 5, 4, '2025-03-27 09:57:00', 3, 240, 'Bilheteira'),
(11337, 1232, 137, 6, 4, '2025-03-13 21:46:00', 3, 240, 'Bilheteira'),
(11338, 1296, 137, 2, 4, '2025-02-25 22:52:00', 3, 240, 'Loja Física'),
(11339, 1356, 139, 5, 4, '2025-04-10 22:19:00', 3, 240, 'Online'),
(11340, 1366, 137, 1, 4, '2025-04-20 10:05:00', 3, 240, 'Desconhecido'),
(11341, 1403, 138, 5, 4, '2025-01-11 15:57:00', 3, 240, 'Online'),
(11342, 1477, 140, 2, 4, '2025-03-12 09:00:00', 3, 240, 'Bilheteira'),
(11343, 1561, 137, 2, 4, '2025-04-06 18:33:00', 3, 240, 'Bilheteira'),
(11344, 1685, 139, 1, 4, '2025-03-13 10:52:00', 3, 240, 'Online'),
(11345, 1696, 140, 5, 4, '2025-01-29 11:27:00', 3, 240, 'Online'),
(11346, 1777, 138, 1, 4, '2025-03-19 18:32:00', 3, 240, 'Loja Física'),
(11347, 1778, 138, 1, 4, '2025-02-19 14:00:00', 3, 240, 'Bilheteira'),
(11348, 1874, 139, 6, 4, '2025-01-23 12:49:00', 3, 240, 'Online'),
(11349, 1878, 139, 6, 4, '2025-03-20 11:27:00', 3, 240, 'Bilheteira'),
(11350, 1931, 138, 1, 4, '2025-03-11 09:42:00', 3, 240, 'Loja Física'),
(11351, 1987, 140, 6, 4, '2025-03-16 15:40:00', 3, 240, 'Loja Física'),
(11352, 1034, 83, 2, 1, '2025-03-21 18:06:00', 4, 48, 'Loja Física'),
(11353, 1044, 81, 2, 1, '2025-04-22 09:54:00', 4, 48, 'Online'),
(11354, 1424, 84, 1, 1, '2025-01-09 14:17:00', 4, 48, 'Bilheteira'),
(11355, 1426, 81, 3, 1, '2025-02-07 13:58:00', 4, 48, 'Desconhecido'),
(11356, 1433, 81, 6, 1, '2025-02-12 19:11:00', 4, 48, 'Loja Física'),
(11357, 1445, 83, 2, 1, '2025-01-26 18:12:00', 4, 48, 'Loja Física'),
(11358, 1452, 81, 3, 1, '2025-02-21 16:17:00', 4, 48, 'Desconhecido'),
(11359, 1486, 82, 5, 1, '2025-02-02 17:46:00', 4, 48, 'Online'),
(11360, 1570, 82, 1, 1, '2025-04-07 16:19:00', 4, 48, 'Bilheteira'),
(11361, 1963, 81, 5, 1, '2025-01-31 14:53:00', 4, 48, 'Bilheteira'),
(11362, 1990, 81, 3, 1, '2025-03-07 18:21:00', 4, 48, 'Bilheteira'),
(11363, 1091, 86, 6, 2, '2025-02-27 20:38:00', 4, 60, 'Bilheteira'),
(11364, 1222, 86, 2, 2, '2025-02-17 21:21:00', 4, 60, 'Bilheteira'),
(11365, 1348, 85, 2, 2, '2025-03-20 18:03:00', 4, 60, 'Loja Física'),
(11366, 1407, 85, 6, 2, '2025-01-20 11:36:00', 4, 60, 'Loja Física'),
(11367, 1441, 88, 6, 2, '2025-04-23 19:16:00', 4, 60, 'Loja Física'),
(11368, 1729, 88, 5, 2, '2025-01-16 12:51:00', 4, 60, 'Loja Física'),
(11369, 1962, 87, 1, 2, '2025-02-25 21:01:00', 4, 60, 'Loja Física'),
(11370, 1968, 88, 6, 2, '2025-03-08 14:37:00', 4, 60, 'Desconhecido'),
(11371, 1973, 86, 6, 2, '2025-02-14 12:12:00', 4, 60, 'Online'),
(11372, 1012, 93, 3, 2, '2025-03-18 10:24:00', 4, 72, 'Loja Física'),
(11373, 1017, 96, 4, 3, '2025-04-15 10:48:00', 4, 72, 'Online'),
(11374, 1032, 96, 4, 3, '2025-03-26 18:36:00', 4, 72, 'Bilheteira'),
(11375, 1175, 92, 5, 3, '2025-02-16 19:46:00', 4, 72, 'Bilheteira'),
(11376, 1178, 91, 5, 3, '2025-04-22 14:35:00', 4, 72, 'Loja Física'),
(11377, 1215, 89, 6, 2, '2025-01-16 13:28:00', 4, 72, 'Online'),
(11378, 1299, 90, 6, 3, '2025-05-01 20:13:00', 4, 72, 'Bilheteira'),
(11379, 1305, 91, 2, 3, '2025-01-14 13:26:00', 4, 72, 'Online'),
(11380, 1338, 95, 2, 2, '2025-02-14 20:13:00', 4, 72, 'Loja Física'),
(11381, 1359, 90, 6, 3, '2025-01-04 12:34:00', 4, 72, 'Loja Física'),
(11382, 1444, 89, 6, 2, '2025-04-17 10:32:00', 4, 72, 'Loja Física'),
(11383, 1462, 89, 3, 2, '2025-02-13 14:52:00', 4, 72, 'Online'),
(11384, 1587, 91, 3, 3, '2025-04-01 16:35:00', 4, 72, 'Loja Física'),
(11385, 1595, 92, 3, 3, '2025-04-13 19:03:00', 4, 72, 'Loja Física'),
(11386, 1604, 96, 5, 3, '2025-02-15 11:08:00', 4, 72, 'Bilheteira'),
(11387, 1635, 90, 2, 3, '2025-04-08 09:59:00', 4, 72, 'Bilheteira'),
(11388, 1708, 95, 5, 2, '2025-02-21 16:19:00', 4, 72, 'Loja Física'),
(11389, 1740, 89, 6, 2, '2025-04-09 19:42:00', 4, 72, 'Bilheteira'),
(11390, 1755, 92, 2, 3, '2025-03-01 21:08:00', 4, 72, 'Bilheteira'),
(11391, 1793, 90, 3, 3, '2025-02-28 10:07:00', 4, 72, 'Online'),
(11392, 1808, 95, 2, 2, '2025-02-21 20:37:00', 4, 72, 'Loja Física'),
(11393, 1952, 96, 6, 3, '2025-02-17 12:28:00', 4, 72, 'Online'),
(11394, 1976, 93, 1, 2, '2025-03-21 12:15:00', 4, 72, 'Loja Física'),
(11395, 1996, 94, 3, 2, '2025-01-30 12:46:00', 4, 72, 'Online'),
(11396, 1006, 98, 1, 2, '2025-03-23 22:23:00', 4, 88, 'Bilheteira'),
(11397, 1014, 102, 5, 1, '2025-01-01 20:56:00', 4, 88, 'Bilheteira'),
(11398, 1086, 103, 1, 2, '2025-03-03 16:21:00', 4, 88, 'Online'),
(11399, 1107, 102, 5, 1, '2025-03-10 16:22:00', 4, 88, 'Loja Física'),
(11400, 1143, 97, 3, 1, '2025-01-09 10:53:00', 4, 88, 'Online'),
(11401, 1163, 97, 1, 1, '2025-01-09 16:28:00', 4, 88, 'Bilheteira'),
(11402, 1217, 141, 6, 1, '2025-03-07 16:31:00', 4, 88, 'Bilheteira'),
(11403, 1297, 97, 3, 1, '2025-02-10 11:25:00', 4, 88, 'Bilheteira'),
(11404, 1303, 98, 5, 2, '2025-01-14 09:06:00', 4, 88, 'Online'),
(11405, 1337, 97, 2, 1, '2025-04-10 22:48:00', 4, 88, 'Loja Física'),
(11406, 1342, 101, 5, 1, '2025-02-19 10:15:00', 4, 88, 'Loja Física'),
(11407, 1417, 100, 5, 2, '2025-03-18 16:11:00', 4, 88, 'Loja Física'),
(11408, 1485, 103, 6, 2, '2025-01-31 19:39:00', 4, 88, 'Online'),
(11409, 1500, 100, 5, 2, '2025-02-27 14:39:00', 4, 88, 'Bilheteira'),
(11410, 1509, 101, 6, 1, '2025-01-30 10:16:00', 4, 88, 'Online'),
(11411, 1528, 102, 1, 1, '2025-03-12 21:35:00', 4, 88, 'Online'),
(11412, 1539, 99, 3, 2, '2025-02-18 18:30:00', 4, 88, 'Bilheteira'),
(11413, 1543, 141, 1, 1, '2025-04-05 12:15:00', 4, 88, 'Online'),
(11414, 1601, 141, 1, 1, '2025-04-09 17:59:00', 4, 88, 'Bilheteira'),
(11415, 1606, 102, 5, 1, '2025-04-16 20:44:00', 4, 88, 'Online'),
(11416, 1655, 98, 5, 2, '2025-03-19 22:20:00', 4, 88, 'Loja Física'),
(11417, 1660, 99, 2, 2, '2025-04-03 18:39:00', 4, 88, 'Online'),
(11418, 1739, 99, 5, 2, '2025-01-01 17:15:00', 4, 88, 'Online'),
(11419, 1742, 97, 6, 1, '2025-02-02 14:39:00', 4, 88, 'Online'),
(11420, 1788, 100, 6, 2, '2025-04-23 20:08:00', 4, 88, 'Online'),
(11421, 1901, 103, 2, 2, '2025-01-15 18:14:00', 4, 88, 'Loja Física'),
(11422, 1938, 100, 2, 2, '2025-03-28 11:03:00', 4, 88, 'Bilheteira'),
(11423, 1939, 103, 1, 2, '2025-01-13 14:09:00', 4, 88, 'Bilheteira'),
(11424, 1043, 109, 2, 3, '2025-01-04 11:47:00', 4, 100, 'Bilheteira'),
(11425, 1002, 142, 3, 3, '2025-03-17 13:51:00', 4, 100, 'Online'),
(11426, 1079, 106, 3, 2, '2025-03-13 21:15:00', 4, 100, 'Bilheteira'),
(11427, 1083, 109, 1, 3, '2025-02-05 20:37:00', 4, 100, 'Loja Física'),
(11428, 1109, 104, 3, 2, '2025-02-19 19:50:00', 4, 100, 'Online'),
(11429, 1137, 108, 3, 2, '2025-04-10 14:32:00', 4, 100, 'Online'),
(11430, 1150, 106, 1, 2, '2025-02-28 14:10:00', 4, 100, 'Bilheteira'),
(11431, 1162, 107, 5, 3, '2025-03-01 21:36:00', 4, 100, 'Bilheteira'),
(11432, 1165, 108, 3, 2, '2025-03-16 17:50:00', 4, 100, 'Online'),
(11433, 1167, 107, 1, 3, '2025-02-26 17:33:00', 4, 100, 'Online'),
(11434, 1264, 110, 5, 3, '2025-04-28 09:35:00', 4, 100, 'Bilheteira'),
(11435, 1295, 142, 1, 3, '2025-01-14 11:19:00', 4, 100, 'Bilheteira'),
(11436, 1326, 110, 3, 3, '2025-03-04 11:36:00', 4, 100, 'Bilheteira'),
(11437, 1365, 106, 2, 2, '2025-02-10 15:07:00', 4, 100, 'Bilheteira'),
(11438, 1370, 109, 5, 3, '2025-02-17 19:40:00', 4, 100, 'Online'),
(11439, 1435, 106, 6, 2, '2025-02-21 15:30:00', 4, 100, 'Online'),
(11440, 1458, 106, 2, 2, '2025-04-22 11:04:00', 4, 100, 'Bilheteira'),
(11441, 1719, 142, 5, 3, '2025-01-14 11:34:00', 4, 100, 'Online'),
(11442, 1737, 104, 1, 2, '2025-03-30 11:13:00', 4, 100, 'Loja Física'),
(11443, 1741, 107, 6, 3, '2025-03-05 11:10:00', 4, 100, 'Online'),
(11444, 1745, 142, 3, 3, '2025-04-25 12:04:00', 4, 100, 'Loja Física'),
(11445, 1814, 108, 5, 2, '2025-01-26 13:42:00', 4, 100, 'Bilheteira'),
(11446, 1833, 110, 2, 3, '2025-01-31 10:09:00', 4, 100, 'Online'),
(11447, 1880, 104, 2, 2, '2025-01-11 21:30:00', 4, 100, 'Online'),
(11448, 1903, 108, 5, 2, '2025-04-18 21:07:00', 4, 100, 'Loja Física'),
(11449, 1911, 104, 1, 2, '2025-04-24 19:44:00', 4, 100, 'Bilheteira'),
(11450, 1955, 107, 4, 3, '2025-01-15 22:17:00', 4, 100, 'Loja Física'),
(11451, 1988, 109, 4, 3, '2025-04-21 12:25:00', 4, 100, 'Bilheteira'),
(11452, 1058, 114, 5, 3, '2025-03-20 22:46:00', 4, 116, 'Bilheteira'),
(11453, 1092, 113, 5, 3, '2025-01-10 19:14:00', 4, 116, 'Loja Física'),
(11454, 1106, 112, 1, 3, '2025-02-13 21:32:00', 4, 116, 'Online'),
(11455, 1138, 112, 3, 3, '2025-03-24 09:03:00', 4, 116, 'Bilheteira'),
(11456, 1140, 113, 5, 3, '2025-03-18 17:18:00', 4, 116, 'Loja Física'),
(11457, 1247, 114, 2, 3, '2025-03-31 17:58:00', 4, 116, 'Loja Física'),
(11458, 1294, 114, 1, 3, '2025-02-08 16:50:00', 4, 116, 'Bilheteira'),
(11459, 1304, 114, 5, 3, '2025-03-01 21:43:00', 4, 116, 'Loja Física'),
(11460, 1412, 111, 3, 3, '2025-04-10 22:20:00', 4, 116, 'Loja Física'),
(11461, 1451, 113, 1, 3, '2025-03-21 13:56:00', 4, 116, 'Online'),
(11462, 1457, 114, 6, 3, '2025-01-20 22:52:00', 4, 116, 'Loja Física'),
(11463, 1475, 112, 5, 3, '2025-01-14 18:55:00', 4, 116, 'Loja Física'),
(11464, 1501, 113, 3, 3, '2025-01-22 09:20:00', 4, 116, 'Online'),
(11465, 1586, 113, 1, 3, '2025-04-04 12:01:00', 4, 116, 'Bilheteira'),
(11466, 1625, 113, 1, 3, '2025-02-20 20:10:00', 4, 116, 'Bilheteira'),
(11467, 1693, 114, 2, 3, '2025-01-20 13:55:00', 4, 116, 'Online'),
(11468, 1733, 114, 2, 3, '2025-02-11 10:43:00', 4, 116, 'Loja Física'),
(11469, 1751, 111, 5, 3, '2025-03-16 12:57:00', 4, 116, 'Online'),
(11470, 1764, 112, 1, 3, '2025-03-29 17:59:00', 4, 116, 'Bilheteira'),
(11471, 1850, 114, 2, 3, '2025-03-03 22:47:00', 4, 116, 'Bilheteira'),
(11472, 1019, 116, 2, 1, '2025-04-26 17:28:00', 4, 140, 'Online'),
(11473, 1028, 116, 3, 1, '2025-03-31 20:50:00', 4, 140, 'Loja Física'),
(11474, 1051, 116, 3, 1, '2025-03-31 13:35:00', 4, 140, 'Online'),
(11475, 1081, 116, 3, 1, '2025-04-06 17:21:00', 4, 140, 'Loja Física'),
(11476, 1279, 115, 2, 1, '2025-01-11 14:25:00', 4, 140, 'Loja Física'),
(11477, 1306, 115, 3, 1, '2025-04-11 12:33:00', 4, 140, 'Bilheteira'),
(11478, 1384, 118, 2, 1, '2025-03-17 10:21:00', 4, 140, 'Bilheteira'),
(11479, 1430, 115, 5, 1, '2025-04-19 10:30:00', 4, 140, 'Loja Física'),
(11480, 1463, 116, 6, 1, '2025-01-15 10:48:00', 4, 140, 'Online'),
(11481, 1512, 118, 1, 1, '2025-04-27 12:33:00', 4, 140, 'Bilheteira'),
(11482, 1573, 115, 1, 1, '2025-01-25 22:04:00', 4, 140, 'Online'),
(11483, 1664, 118, 5, 1, '2025-03-22 17:53:00', 4, 140, 'Loja Física'),
(11484, 1722, 117, 3, 1, '2025-03-15 09:32:00', 4, 140, 'Bilheteira'),
(11485, 1724, 115, 5, 3, '2025-01-08 19:41:00', 4, 140, 'Bilheteira'),
(11486, 1771, 117, 6, 1, '2025-03-11 11:34:00', 4, 140, 'Online'),
(11487, 1948, 115, 2, 1, '2025-02-04 12:42:00', 4, 140, 'Bilheteira'),
(11488, 1131, 120, 1, 1, '2025-01-31 22:23:00', 4, 160, 'Loja Física'),
(11489, 1168, 143, 1, 1, '2025-04-10 14:43:00', 4, 160, 'Online'),
(11490, 1190, 120, 3, 1, '2025-03-22 11:51:00', 4, 160, 'Online'),
(11491, 1254, 121, 2, 1, '2025-02-18 10:43:00', 4, 160, 'Loja Física'),
(11492, 1273, 143, 2, 1, '2025-02-28 11:46:00', 4, 160, 'Online'),
(11493, 1399, 121, 5, 1, '2025-04-25 19:16:00', 4, 160, 'Loja Física'),
(11494, 1558, 143, 3, 1, '2025-04-24 10:24:00', 4, 160, 'Bilheteira'),
(11495, 1661, 143, 2, 1, '2025-04-13 09:41:00', 4, 160, 'Bilheteira'),
(11496, 1680, 143, 3, 1, '2025-01-04 10:30:00', 4, 160, 'Bilheteira'),
(11497, 1792, 143, 5, 1, '2025-02-13 11:06:00', 4, 160, 'Online'),
(11498, 1846, 119, 3, 1, '2025-04-05 15:59:00', 4, 160, 'Loja Física'),
(11499, 1877, 120, 4, 1, '2025-04-24 15:30:00', 4, 160, 'Loja Física'),
(11500, 1974, 120, 1, 1, '2025-03-18 20:21:00', 4, 160, 'Loja Física'),
(11501, 1056, 122, 6, 3, '2025-02-01 11:41:00', 4, 196, 'Online'),
(11502, 1089, 122, 5, 3, '2025-02-08 22:37:00', 4, 196, 'Bilheteira'),
(11503, 1099, 125, 3, 3, '2025-02-06 19:25:00', 4, 196, 'Online'),
(11504, 1237, 122, 1, 3, '2025-03-25 12:48:00', 4, 196, 'Bilheteira'),
(11505, 1239, 124, 6, 3, '2025-01-24 20:55:00', 4, 196, 'Online'),
(11506, 1259, 124, 5, 3, '2025-01-30 17:13:00', 4, 196, 'Online'),
(11507, 1491, 125, 6, 3, '2025-02-27 19:25:00', 4, 196, 'Bilheteira'),
(11508, 1510, 125, 1, 3, '2025-04-28 16:56:00', 4, 196, 'Online'),
(11509, 1547, 124, 3, 3, '2025-05-01 17:02:00', 4, 196, 'Bilheteira'),
(11510, 1610, 124, 2, 3, '2025-04-07 18:36:00', 4, 196, 'Online'),
(11511, 1683, 123, 3, 3, '2025-01-09 14:13:00', 4, 196, 'Loja Física'),
(11512, 1709, 122, 1, 3, '2025-02-03 11:33:00', 4, 196, 'Online'),
(11513, 1875, 123, 6, 3, '2025-02-06 19:48:00', 4, 196, 'Online'),
(11514, 1943, 125, 2, 3, '2025-01-11 22:40:00', 4, 196, 'Online'),
(11515, 1950, 122, 6, 3, '2025-03-10 10:50:00', 4, 196, 'Loja Física'),
(11516, 1077, 126, 1, 4, '2025-04-19 14:11:00', 4, 200, 'Online'),
(11517, 1087, 127, 6, 4, '2025-03-04 10:36:00', 4, 200, 'Loja Física'),
(11518, 1098, 128, 6, 4, '2025-02-14 15:21:00', 4, 200, 'Desconhecido'),
(11519, 1185, 127, 5, 4, '2025-03-18 17:01:00', 4, 200, 'Loja Física'),
(11520, 1188, 128, 6, 4, '2025-02-17 13:47:00', 4, 200, 'Bilheteira'),
(11521, 1270, 128, 1, 4, '2025-04-08 22:20:00', 4, 200, 'Bilheteira'),
(11522, 1455, 128, 1, 4, '2025-02-26 09:04:00', 4, 200, 'Loja Física'),
(11523, 1515, 126, 2, 4, '2025-03-28 16:30:00', 4, 200, 'Loja Física');
INSERT INTO `vendas` (`id`, `id_venda`, `id_produto`, `id_cidade`, `id_categoria`, `DataHora`, `Quantidade`, `Receita`, `canal_venda`) VALUES
(11524, 1612, 126, 2, 4, '2025-03-06 15:49:00', 4, 200, 'Online'),
(11525, 1622, 127, 6, 4, '2025-03-26 13:42:00', 4, 200, 'Bilheteira'),
(11526, 1638, 127, 5, 4, '2025-02-28 22:56:00', 4, 200, 'Online'),
(11527, 1678, 129, 3, 4, '2025-01-13 16:19:00', 4, 200, 'Loja Física'),
(11528, 1753, 128, 3, 4, '2025-03-05 12:05:00', 4, 200, 'Online'),
(11529, 1774, 126, 6, 4, '2025-04-26 09:08:00', 4, 200, 'Loja Física'),
(11530, 1823, 126, 3, 4, '2025-03-17 09:20:00', 4, 200, 'Loja Física'),
(11531, 1837, 126, 6, 4, '2025-05-01 22:46:00', 4, 200, 'Online'),
(11532, 1840, 126, 5, 4, '2025-03-10 14:44:00', 4, 200, 'Bilheteira'),
(11533, 1844, 128, 1, 4, '2025-04-29 13:19:00', 4, 200, 'Online'),
(11534, 1867, 128, 3, 4, '2025-01-06 16:22:00', 4, 200, 'Loja Física'),
(11535, 1886, 127, 3, 4, '2025-01-15 09:10:00', 4, 200, 'Bilheteira'),
(11536, 1893, 126, 5, 4, '2025-02-21 16:32:00', 4, 200, 'Loja Física'),
(11537, 1917, 126, 5, 4, '2025-02-13 12:51:00', 4, 200, 'Loja Física'),
(11538, 1967, 129, 5, 4, '2025-02-19 16:50:00', 4, 200, 'Loja Física'),
(11539, 1985, 129, 5, 4, '2025-04-12 19:39:00', 4, 200, 'Online'),
(11540, 1070, 132, 5, 4, '2025-03-31 13:49:00', 4, 240, 'Online'),
(11541, 1027, 131, 3, 4, '2025-04-26 09:10:00', 4, 240, 'Online'),
(11542, 1119, 130, 5, 4, '2025-04-20 16:06:00', 4, 240, 'Bilheteira'),
(11543, 1199, 132, 2, 4, '2025-02-17 14:28:00', 4, 240, 'Loja Física'),
(11544, 1309, 131, 3, 4, '2025-03-22 11:11:00', 4, 240, 'Loja Física'),
(11545, 1310, 132, 2, 4, '2025-03-17 15:24:00', 4, 240, 'Loja Física'),
(11546, 1336, 132, 1, 4, '2025-01-12 20:51:00', 4, 240, 'Online'),
(11547, 1520, 132, 5, 4, '2025-02-19 11:06:00', 4, 240, 'Online'),
(11548, 1772, 131, 5, 4, '2025-04-29 14:09:00', 4, 240, 'Loja Física'),
(11549, 1025, 135, 5, 4, '2025-02-01 22:59:00', 4, 280, 'Bilheteira'),
(11550, 1052, 135, 2, 4, '2025-03-12 22:00:00', 4, 280, 'Bilheteira'),
(11551, 1060, 135, 1, 4, '2025-01-10 20:18:00', 4, 280, 'Bilheteira'),
(11552, 1177, 134, 5, 4, '2025-03-06 17:26:00', 4, 280, 'Online'),
(11553, 1292, 136, 2, 4, '2025-02-19 21:05:00', 4, 280, 'Loja Física'),
(11554, 1400, 135, 3, 4, '2025-02-17 11:28:00', 4, 280, 'Bilheteira'),
(11555, 1422, 134, 5, 4, '2025-02-02 12:29:00', 4, 280, 'Loja Física'),
(11556, 1551, 144, 5, 4, '2025-02-05 16:11:00', 4, 280, 'Online'),
(11557, 1568, 144, 1, 4, '2025-03-11 12:51:00', 4, 280, 'Bilheteira'),
(11558, 1640, 144, 4, 4, '2025-01-22 15:18:00', 4, 280, 'Online'),
(11559, 1697, 135, 6, 4, '2025-04-29 17:36:00', 4, 280, 'Online'),
(11560, 1766, 144, 3, 4, '2025-03-17 19:44:00', 4, 280, 'Loja Física'),
(11561, 1865, 135, 3, 4, '2025-04-08 11:35:00', 4, 280, 'Loja Física'),
(11562, 1991, 134, 3, 4, '2025-02-10 13:24:00', 4, 280, 'Online'),
(11563, 1053, 137, 2, 4, '2025-02-26 19:13:00', 4, 320, 'Bilheteira'),
(11564, 1059, 138, 4, 4, '2025-02-03 21:15:00', 4, 320, 'Bilheteira'),
(11565, 1063, 139, 5, 4, '2025-01-01 14:19:00', 4, 320, 'Bilheteira'),
(11566, 1142, 137, 1, 4, '2025-02-23 20:06:00', 4, 320, 'Bilheteira'),
(11567, 1318, 140, 2, 4, '2025-03-04 11:05:00', 4, 320, 'Online'),
(11568, 1613, 138, 5, 4, '2025-03-25 18:12:00', 4, 320, 'Loja Física'),
(11569, 1637, 138, 1, 4, '2025-04-10 09:38:00', 4, 320, 'Bilheteira'),
(11570, 1662, 137, 5, 4, '2025-04-29 20:03:00', 4, 320, 'Bilheteira'),
(11571, 1692, 140, 2, 4, '2025-03-11 12:42:00', 4, 320, 'Bilheteira'),
(11572, 1922, 140, 5, 4, '2025-04-04 15:52:00', 4, 320, 'Online'),
(11573, 1013, 83, 6, 1, '2025-04-07 13:49:00', 5, 60, 'Bilheteira'),
(11574, 1189, 81, 1, 1, '2025-04-05 21:21:00', 5, 60, 'Online'),
(11575, 1203, 84, 2, 1, '2025-03-11 13:57:00', 5, 60, 'Online'),
(11576, 1459, 84, 2, 1, '2025-01-29 17:41:00', 5, 60, 'Bilheteira'),
(11577, 1699, 82, 6, 1, '2025-04-24 18:05:00', 5, 60, 'Bilheteira'),
(11578, 1734, 81, 4, 1, '2025-01-23 14:04:00', 5, 60, 'Bilheteira'),
(11579, 1786, 82, 3, 1, '2025-04-06 14:37:00', 5, 60, 'Loja Física'),
(11580, 1791, 84, 2, 1, '2025-03-16 14:52:00', 5, 60, 'Online'),
(11581, 1842, 84, 2, 1, '2025-01-05 22:47:00', 5, 60, 'Online'),
(11582, 1020, 88, 6, 2, '2025-03-12 12:37:00', 5, 75, 'Online'),
(11583, 1031, 86, 6, 2, '2025-01-09 19:55:00', 5, 75, 'Bilheteira'),
(11584, 1049, 85, 2, 2, '2025-04-29 21:34:00', 5, 75, 'Loja Física'),
(11585, 1355, 88, 6, 2, '2025-03-28 09:11:00', 5, 75, 'Loja Física'),
(11586, 1545, 85, 1, 2, '2025-01-06 22:30:00', 5, 75, 'Loja Física'),
(11587, 1801, 87, 5, 2, '2025-01-28 20:12:00', 5, 75, 'Online'),
(11588, 1932, 86, 5, 2, '2025-03-22 21:49:00', 5, 75, 'Bilheteira'),
(11589, 1007, 91, 2, 3, '2025-03-23 11:34:00', 5, 90, 'Online'),
(11590, 1093, 92, 6, 3, '2025-01-29 19:09:00', 5, 90, 'Desconhecido'),
(11591, 1144, 89, 6, 2, '2025-01-08 18:35:00', 5, 90, 'Bilheteira'),
(11592, 1170, 91, 3, 3, '2025-03-26 11:58:00', 5, 90, 'Bilheteira'),
(11593, 1174, 89, 5, 2, '2025-02-18 11:10:00', 5, 90, 'Loja Física'),
(11594, 1195, 94, 1, 2, '2025-02-07 14:06:00', 5, 90, 'Bilheteira'),
(11595, 1209, 89, 5, 2, '2025-02-05 11:40:00', 5, 90, 'Loja Física'),
(11596, 1238, 95, 3, 2, '2025-04-05 20:54:00', 5, 90, 'Online'),
(11597, 1268, 94, 1, 2, '2025-04-01 12:25:00', 5, 90, 'Loja Física'),
(11598, 1311, 91, 1, 3, '2025-01-14 21:55:00', 5, 90, 'Online'),
(11599, 1382, 90, 2, 3, '2025-03-03 09:21:00', 5, 90, 'Online'),
(11600, 1431, 94, 1, 2, '2025-01-16 22:43:00', 5, 90, 'Loja Física'),
(11601, 1494, 94, 1, 2, '2025-01-29 11:47:00', 5, 90, 'Loja Física'),
(11602, 1548, 92, 2, 3, '2025-02-28 14:44:00', 5, 90, 'Online'),
(11603, 1557, 89, 1, 2, '2025-03-15 19:41:00', 5, 90, 'Online'),
(11604, 1591, 94, 5, 2, '2025-03-29 16:49:00', 5, 90, 'Online'),
(11605, 1597, 95, 2, 2, '2025-02-19 12:12:00', 5, 90, 'Loja Física'),
(11606, 1598, 92, 3, 3, '2025-02-15 19:29:00', 5, 90, 'Loja Física'),
(11607, 1599, 93, 5, 2, '2025-02-21 17:21:00', 5, 90, 'Online'),
(11608, 1624, 93, 6, 2, '2025-02-28 17:59:00', 5, 90, 'Online'),
(11609, 1687, 93, 2, 2, '2025-04-26 21:40:00', 5, 90, 'Online'),
(11610, 1790, 90, 1, 3, '2025-04-07 11:34:00', 5, 90, 'Bilheteira'),
(11611, 1802, 95, 5, 2, '2025-04-19 20:30:00', 5, 90, 'Loja Física'),
(11612, 1852, 96, 3, 3, '2025-03-24 18:40:00', 5, 90, 'Online'),
(11613, 1854, 89, 3, 2, '2025-01-16 09:45:00', 5, 90, 'Bilheteira'),
(11614, 1915, 96, 3, 3, '2025-03-17 13:15:00', 5, 90, 'Loja Física'),
(11615, 1935, 92, 3, 3, '2025-03-19 14:25:00', 5, 90, 'Online'),
(11616, 1969, 95, 3, 2, '2025-01-17 19:32:00', 5, 90, 'Bilheteira'),
(11617, 1073, 103, 1, 2, '2025-02-24 19:23:00', 5, 110, 'Loja Física'),
(11618, 1094, 100, 6, 2, '2025-04-06 22:36:00', 5, 110, 'Bilheteira'),
(11619, 1096, 98, 5, 2, '2025-02-02 09:05:00', 5, 110, 'Loja Física'),
(11620, 1102, 100, 6, 2, '2025-01-17 13:28:00', 5, 110, 'Bilheteira'),
(11621, 1176, 102, 1, 1, '2025-01-31 13:51:00', 5, 110, 'Online'),
(11622, 1205, 102, 3, 1, '2025-04-24 10:04:00', 5, 110, 'Bilheteira'),
(11623, 1255, 101, 6, 1, '2025-02-20 17:08:00', 5, 110, 'Online'),
(11624, 1283, 103, 6, 2, '2025-03-14 19:02:00', 5, 110, 'Bilheteira'),
(11625, 1320, 103, 3, 2, '2025-04-16 14:34:00', 5, 110, 'Loja Física'),
(11626, 1330, 97, 6, 1, '2025-04-20 16:50:00', 5, 110, 'Loja Física'),
(11627, 1345, 98, 6, 2, '2025-04-09 15:27:00', 5, 110, 'Bilheteira'),
(11628, 1378, 98, 2, 2, '2025-01-30 11:06:00', 5, 110, 'Loja Física'),
(11629, 1379, 101, 2, 1, '2025-04-19 21:24:00', 5, 110, 'Online'),
(11630, 1408, 103, 3, 2, '2025-04-23 14:56:00', 5, 110, 'Bilheteira'),
(11631, 1456, 100, 3, 2, '2025-03-08 20:44:00', 5, 110, 'Online'),
(11632, 1480, 98, 6, 2, '2025-02-03 11:10:00', 5, 110, 'Bilheteira'),
(11633, 1506, 102, 5, 1, '2025-04-04 22:18:00', 5, 110, 'Bilheteira'),
(11634, 1507, 98, 2, 2, '2025-01-02 19:15:00', 5, 110, 'Loja Física'),
(11635, 1511, 99, 3, 2, '2025-03-11 18:11:00', 5, 110, 'Loja Física'),
(11636, 1626, 97, 3, 1, '2025-02-05 21:03:00', 5, 110, 'Bilheteira'),
(11637, 1663, 101, 2, 1, '2025-03-29 14:51:00', 5, 110, 'Online'),
(11638, 1800, 97, 5, 1, '2025-04-10 20:39:00', 5, 110, 'Loja Física'),
(11639, 1806, 102, 6, 1, '2025-02-22 13:54:00', 5, 110, 'Online'),
(11640, 1847, 100, 5, 2, '2025-01-09 14:26:00', 5, 110, 'Loja Física'),
(11641, 1925, 103, 1, 2, '2025-02-07 09:33:00', 5, 110, 'Online'),
(11642, 1944, 141, 3, 1, '2025-02-24 17:28:00', 5, 110, 'Online'),
(11643, 1467, 105, 6, 2, '2025-03-06 11:31:00', 5, 125, 'Loja Física'),
(11644, 1629, 109, 1, 3, '2025-03-11 19:51:00', 5, 125, 'Online'),
(11645, 1030, 108, 5, 2, '2025-04-28 22:33:00', 5, 125, 'Online'),
(11646, 1065, 142, 5, 3, '2025-03-10 09:58:00', 5, 125, 'Loja Física'),
(11647, 1154, 106, 2, 2, '2025-01-08 09:13:00', 5, 125, 'Online'),
(11648, 1216, 104, 5, 2, '2025-02-23 12:55:00', 5, 125, 'Bilheteira'),
(11649, 1256, 104, 3, 2, '2025-02-24 17:24:00', 5, 125, 'Online'),
(11650, 1402, 104, 3, 2, '2025-01-30 17:03:00', 5, 125, 'Desconhecido'),
(11651, 1406, 108, 3, 2, '2025-02-20 17:20:00', 5, 125, 'Loja Física'),
(11652, 1460, 105, 1, 2, '2025-02-27 10:54:00', 5, 125, 'Bilheteira'),
(11653, 1476, 142, 6, 3, '2025-04-11 21:51:00', 5, 125, 'Bilheteira'),
(11654, 1483, 106, 2, 2, '2025-03-10 15:05:00', 5, 125, 'Online'),
(11655, 1628, 142, 3, 3, '2025-01-20 15:19:00', 5, 125, 'Bilheteira'),
(11656, 1630, 142, 5, 3, '2025-04-28 11:20:00', 5, 125, 'Loja Física'),
(11657, 1749, 110, 6, 3, '2025-04-26 11:36:00', 5, 125, 'Online'),
(11658, 1862, 110, 6, 3, '2025-03-05 14:56:00', 5, 125, 'Online'),
(11659, 1869, 110, 3, 3, '2025-01-01 17:49:00', 5, 125, 'Online'),
(11660, 1899, 109, 1, 3, '2025-03-04 10:50:00', 5, 125, 'Bilheteira'),
(11661, 1015, 112, 5, 3, '2025-03-19 12:09:00', 5, 145, 'Online'),
(11662, 1037, 113, 1, 3, '2025-01-27 20:21:00', 5, 145, 'Loja Física'),
(11663, 1042, 112, 4, 3, '2025-04-24 22:26:00', 5, 145, 'Loja Física'),
(11664, 1171, 112, 5, 3, '2025-02-18 19:50:00', 5, 145, 'Online'),
(11665, 1286, 112, 6, 3, '2025-04-09 18:38:00', 5, 145, 'Desconhecido'),
(11666, 1358, 114, 5, 3, '2025-03-05 21:49:00', 5, 145, 'Loja Física'),
(11667, 1380, 113, 5, 3, '2025-01-04 20:44:00', 5, 145, 'Loja Física'),
(11668, 1675, 112, 2, 3, '2025-04-25 14:34:00', 5, 145, 'Online'),
(11669, 1783, 114, 1, 3, '2025-03-04 09:52:00', 5, 145, 'Loja Física'),
(11670, 1078, 115, 2, 1, '2025-03-31 13:35:00', 5, 175, 'Loja Física'),
(11671, 1351, 118, 1, 1, '2025-03-22 10:31:00', 5, 175, 'Loja Física'),
(11672, 1464, 115, 2, 1, '2025-03-08 14:44:00', 5, 175, 'Desconhecido'),
(11673, 1541, 116, 1, 1, '2025-03-10 09:44:00', 5, 175, 'Online'),
(11674, 1556, 115, 3, 1, '2025-03-13 21:16:00', 5, 175, 'Online'),
(11675, 1596, 118, 2, 1, '2025-01-06 20:04:00', 5, 175, 'Online'),
(11676, 1609, 118, 2, 1, '2025-03-14 11:20:00', 5, 175, 'Loja Física'),
(11677, 1616, 117, 3, 1, '2025-04-16 21:28:00', 5, 175, 'Online'),
(11678, 1700, 118, 3, 1, '2025-04-10 09:30:00', 5, 175, 'Loja Física'),
(11679, 1828, 118, 1, 1, '2025-04-13 13:27:00', 5, 175, 'Loja Física'),
(11680, 1912, 118, 2, 1, '2025-03-20 11:44:00', 5, 175, 'Bilheteira'),
(11681, 1048, 143, 1, 1, '2025-03-07 10:24:00', 5, 200, 'Online'),
(11682, 1147, 120, 5, 1, '2025-04-09 22:39:00', 5, 200, 'Loja Física'),
(11683, 1221, 119, 5, 1, '2025-02-27 21:35:00', 5, 200, 'Loja Física'),
(11684, 1225, 143, 4, 1, '2025-02-08 16:52:00', 5, 200, 'Bilheteira'),
(11685, 1269, 121, 5, 1, '2025-03-25 14:19:00', 5, 200, 'Bilheteira'),
(11686, 1469, 121, 3, 1, '2025-04-28 20:48:00', 5, 200, 'Bilheteira'),
(11687, 1538, 120, 1, 1, '2025-01-14 17:04:00', 5, 200, 'Bilheteira'),
(11688, 1656, 120, 5, 1, '2025-04-04 19:31:00', 5, 200, 'Online'),
(11689, 1702, 119, 5, 1, '2025-01-22 18:03:00', 5, 200, 'Bilheteira'),
(11690, 1775, 119, 1, 1, '2025-04-18 12:28:00', 5, 200, 'Online'),
(11691, 1834, 121, 2, 1, '2025-02-25 15:41:00', 5, 200, 'Online'),
(11692, 1929, 121, 3, 1, '2025-01-17 21:08:00', 5, 200, 'Loja Física'),
(11693, 1116, 124, 2, 3, '2025-03-29 12:31:00', 5, 245, 'Online'),
(11694, 1166, 125, 4, 3, '2025-01-20 09:28:00', 5, 245, 'Bilheteira'),
(11695, 1248, 124, 6, 3, '2025-04-01 14:04:00', 5, 245, 'Online'),
(11696, 1381, 123, 6, 3, '2025-02-09 11:31:00', 5, 245, 'Online'),
(11697, 1395, 123, 1, 3, '2025-04-03 20:34:00', 5, 245, 'Loja Física'),
(11698, 1420, 125, 3, 3, '2025-01-03 22:49:00', 5, 245, 'Online'),
(11699, 1498, 124, 6, 3, '2025-01-10 13:42:00', 5, 245, 'Bilheteira'),
(11700, 1550, 125, 2, 3, '2025-02-13 14:11:00', 5, 245, 'Bilheteira'),
(11701, 1695, 122, 5, 3, '2025-04-30 15:39:00', 5, 245, 'Bilheteira'),
(11702, 1859, 122, 6, 3, '2025-02-02 10:06:00', 5, 245, 'Online'),
(11703, 1998, 122, 1, 3, '2025-01-04 14:08:00', 5, 245, 'Online'),
(11704, 1072, 129, 1, 4, '2025-03-30 22:40:00', 5, 250, 'Online'),
(11705, 1141, 127, 2, 4, '2025-04-03 22:13:00', 5, 250, 'Bilheteira'),
(11706, 1274, 129, 4, 4, '2025-01-05 22:54:00', 5, 250, 'Loja Física'),
(11707, 1276, 126, 3, 4, '2025-03-23 19:59:00', 5, 250, 'Bilheteira'),
(11708, 1362, 127, 5, 4, '2025-01-18 19:52:00', 5, 250, 'Online'),
(11709, 1374, 129, 3, 4, '2025-03-21 18:15:00', 5, 250, 'Bilheteira'),
(11710, 1423, 127, 5, 4, '2025-03-26 22:53:00', 5, 250, 'Loja Física'),
(11711, 1492, 127, 6, 4, '2025-01-09 21:47:00', 5, 250, 'Online'),
(11712, 1513, 128, 6, 4, '2025-04-23 11:28:00', 5, 250, 'Online'),
(11713, 1523, 126, 1, 4, '2025-02-24 12:51:00', 5, 250, 'Desconhecido'),
(11714, 1590, 129, 1, 4, '2025-04-20 14:49:00', 5, 250, 'Online'),
(11715, 1648, 128, 3, 4, '2025-04-23 16:15:00', 5, 250, 'Loja Física'),
(11716, 1686, 127, 6, 4, '2025-04-09 22:24:00', 5, 250, 'Bilheteira'),
(11717, 1698, 126, 5, 4, '2025-03-03 20:05:00', 5, 250, 'Loja Física'),
(11718, 1723, 128, 6, 4, '2025-01-29 09:24:00', 5, 250, 'Bilheteira'),
(11719, 1894, 129, 6, 4, '2025-01-03 15:36:00', 5, 250, 'Loja Física'),
(11720, 1519, 133, 1, 4, '2025-03-26 17:16:00', 5, 300, 'Loja Física'),
(11721, 1022, 133, 2, 4, '2025-03-15 16:15:00', 5, 300, 'Bilheteira'),
(11722, 1057, 133, 3, 4, '2025-03-01 09:35:00', 5, 300, 'Online'),
(11723, 1315, 131, 5, 4, '2025-02-19 15:11:00', 5, 300, 'Loja Física'),
(11724, 1387, 132, 5, 4, '2025-02-10 21:39:00', 5, 300, 'Loja Física'),
(11725, 1419, 132, 2, 4, '2025-04-10 12:54:00', 5, 300, 'Loja Física'),
(11726, 1454, 131, 2, 4, '2025-02-18 21:22:00', 5, 300, 'Online'),
(11727, 1468, 131, 3, 4, '2025-01-23 20:52:00', 5, 300, 'Online'),
(11728, 1503, 132, 2, 4, '2025-01-11 22:17:00', 5, 300, 'Loja Física'),
(11729, 1567, 133, 5, 4, '2025-03-18 16:40:00', 5, 300, 'Loja Física'),
(11730, 1608, 132, 6, 4, '2025-04-29 09:40:00', 5, 300, 'Bilheteira'),
(11731, 1654, 133, 4, 4, '2025-01-08 10:36:00', 5, 300, 'Loja Física'),
(11732, 1712, 131, 2, 4, '2025-04-09 12:33:00', 5, 300, 'Loja Física'),
(11733, 1750, 131, 3, 4, '2025-03-02 22:29:00', 5, 300, 'Online'),
(11734, 1818, 131, 3, 4, '2025-01-08 15:16:00', 5, 300, 'Loja Física'),
(11735, 1008, 134, 6, 4, '2025-01-29 19:20:00', 5, 350, 'Online'),
(11736, 1018, 135, 2, 4, '2025-04-22 18:27:00', 5, 350, 'Loja Física'),
(11737, 1075, 135, 3, 4, '2025-04-14 17:49:00', 5, 350, 'Bilheteira'),
(11738, 1112, 136, 5, 4, '2025-02-18 14:40:00', 5, 350, 'Bilheteira'),
(11739, 1157, 136, 3, 4, '2025-02-24 18:25:00', 5, 350, 'Loja Física'),
(11740, 1219, 134, 1, 4, '2025-01-02 22:06:00', 5, 350, 'Online'),
(11741, 1328, 134, 3, 4, '2025-01-01 22:49:00', 5, 350, 'Online'),
(11742, 1391, 134, 4, 4, '2025-02-18 10:53:00', 5, 350, 'Loja Física'),
(11743, 1478, 135, 2, 4, '2025-03-11 20:38:00', 5, 350, 'Loja Física'),
(11744, 1529, 144, 2, 4, '2025-02-14 21:45:00', 5, 350, 'Loja Física'),
(11745, 1600, 144, 3, 4, '2025-02-11 22:23:00', 5, 350, 'Loja Física'),
(11746, 1710, 134, 1, 4, '2025-03-29 09:06:00', 5, 350, 'Loja Física'),
(11747, 1735, 135, 2, 4, '2025-01-22 16:15:00', 5, 350, 'Online'),
(11748, 1810, 134, 1, 4, '2025-03-17 13:48:00', 5, 350, 'Bilheteira'),
(11749, 1887, 134, 3, 4, '2025-04-15 18:23:00', 5, 350, 'Loja Física'),
(11750, 1921, 136, 1, 4, '2025-02-21 18:35:00', 5, 350, 'Bilheteira'),
(11751, 1959, 134, 6, 4, '2025-04-08 09:56:00', 5, 350, 'Online'),
(11752, 1971, 144, 3, 4, '2025-04-24 17:49:00', 5, 350, 'Online'),
(11753, 1983, 144, 5, 4, '2025-02-24 19:15:00', 5, 350, 'Loja Física'),
(11754, 1152, 140, 6, 4, '2025-02-26 15:17:00', 5, 400, 'Loja Física'),
(11755, 1212, 139, 3, 4, '2025-02-07 19:19:00', 5, 400, 'Online'),
(11756, 1301, 139, 3, 4, '2025-03-03 18:25:00', 5, 400, 'Loja Física'),
(11757, 1639, 139, 3, 4, '2025-04-08 19:03:00', 5, 400, 'Bilheteira'),
(11758, 1688, 137, 1, 4, '2025-03-15 16:12:00', 5, 400, 'Loja Física'),
(11759, 1811, 140, 6, 4, '2025-02-05 11:49:00', 5, 400, 'Online'),
(11760, 1986, 137, 5, 4, '2025-03-01 11:20:00', 5, 400, 'Bilheteira');

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `cidade`
--
ALTER TABLE `cidade`
  ADD CONSTRAINT `FK_cidade_core_concelhos` FOREIGN KEY (`id_concelho`) REFERENCES `core_concelhos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_cidade_core_distritos` FOREIGN KEY (`id_distrito`) REFERENCES `core_distritos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_concelhos`
--
ALTER TABLE `core_concelhos`
  ADD CONSTRAINT `FK_core_concelhos_core_distritos` FOREIGN KEY (`id_distrito`) REFERENCES `core_distritos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_empresa`
--
ALTER TABLE `core_empresa`
  ADD CONSTRAINT `FK_core_empresa_core_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `core_idioma` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_empresa_core_user` FOREIGN KEY (`id_user`) REFERENCES `core_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_funcao`
--
ALTER TABLE `core_funcao`
  ADD CONSTRAINT `FK_core_funcao_core_departamento` FOREIGN KEY (`id_depart`) REFERENCES `core_departamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_login`
--
ALTER TABLE `core_login`
  ADD CONSTRAINT `FK_core_login_core_tipologin` FOREIGN KEY (`id_tipo`) REFERENCES `core_tipologin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_login_core_user` FOREIGN KEY (`id_user`) REFERENCES `core_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `core_login_ibfk_1` FOREIGN KEY (`id_lang`) REFERENCES `core_idioma` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_notification`
--
ALTER TABLE `core_notification`
  ADD CONSTRAINT `FK_core_notification_core_user` FOREIGN KEY (`id_user`) REFERENCES `core_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_notification_core_user_2` FOREIGN KEY (`id_sent`) REFERENCES `core_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_permissao`
--
ALTER TABLE `core_permissao`
  ADD CONSTRAINT `FK_core_permissao_core_tipopermissao` FOREIGN KEY (`id_tipo`) REFERENCES `core_tipopermissao` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_rel_tipouser_permissao`
--
ALTER TABLE `core_rel_tipouser_permissao`
  ADD CONSTRAINT `FK_core_rel_tipouser_permissao_core_permissao` FOREIGN KEY (`id_perm`) REFERENCES `core_permissao` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_rel_tipouser_permissao_core_tipouser` FOREIGN KEY (`id_tipo`) REFERENCES `core_tipouser` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_tipopermissao`
--
ALTER TABLE `core_tipopermissao`
  ADD CONSTRAINT `FK_core_tipopermissao_pro_module` FOREIGN KEY (`id_module`) REFERENCES `core_module` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_user`
--
ALTER TABLE `core_user`
  ADD CONSTRAINT `FK_core_user_core_departamento` FOREIGN KEY (`id_departamento`) REFERENCES `core_departamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_user_core_funcao` FOREIGN KEY (`id_funcao`) REFERENCES `core_funcao` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_user_core_tipocont` FOREIGN KEY (`id_tipocont`) REFERENCES `core_tipocont` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_user_core_tipouser` FOREIGN KEY (`id_tipouser`) REFERENCES `core_tipouser` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_user_core_user_hl` FOREIGN KEY (`id_hl`) REFERENCES `core_user_hl` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_user_core_user_sexo` FOREIGN KEY (`id_sexo`) REFERENCES `core_user_sexo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `core_user_dash`
--
ALTER TABLE `core_user_dash`
  ADD CONSTRAINT `FK_core_user_dash_core_dashboard` FOREIGN KEY (`id_dash`) REFERENCES `core_dashboard` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_core_user_dash_core_user` FOREIGN KEY (`id_user`) REFERENCES `core_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `produtos`
--
ALTER TABLE `produtos`
  ADD CONSTRAINT `produtos_Tipo_produto_FK` FOREIGN KEY (`id_tipo_produto`) REFERENCES `tipo_produto` (`id`);

--
-- Limitadores para a tabela `session_messages`
--
ALTER TABLE `session_messages`
  ADD CONSTRAINT `FK_session_messages_core_user` FOREIGN KEY (`id_user`) REFERENCES `core_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `session_messages_users`
--
ALTER TABLE `session_messages_users`
  ADD CONSTRAINT `FK_session_messages_users_core_user` FOREIGN KEY (`id_user`) REFERENCES `core_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_session_messages_users_session_messages` FOREIGN KEY (`id_session`) REFERENCES `session_messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `vendas`
--
ALTER TABLE `vendas`
  ADD CONSTRAINT `vendas_categorias_FK` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`),
  ADD CONSTRAINT `vendas_cidade_FK` FOREIGN KEY (`id_cidade`) REFERENCES `cidade` (`id`),
  ADD CONSTRAINT `vendas_produtos_FK` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
