-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 03-Mar-2026 às 23:06
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

CREATE TABLE IF NOT EXISTS `categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) NOT NULL,
  `total_produtos` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total_vendas` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total_receita` decimal(14,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `categorias`
--

INSERT INTO `categorias` (`id`, `descricao`, `total_produtos`, `total_vendas`, `total_receita`) VALUES
(1, 'Equipamento', 16, 245, 20787.00),
(2, 'Bilhetes', 16, 247, 14504.00),
(3, 'Roupa', 18, 235, 22319.00),
(4, 'Formação', 16, 253, 51210.00);

-- --------------------------------------------------------

--
-- Estrutura da tabela `cidade`
--

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
(1, 'Coimbra', 6, 73),
(2, 'Porto', 13, 190),
(3, 'Braga', 3, 36),
(4, 'Desconhecido', NULL, NULL),
(5, 'Aveiro', 1, 5),
(6, 'Lisboa', 11, 153);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_concelhos`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=13722 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `vendas`
--

INSERT INTO `vendas` (`id`, `id_venda`, `id_produto`, `id_cidade`, `id_categoria`, `DataHora`, `Quantidade`, `Receita`, `canal_venda`) VALUES
(12742, 1122, 81, 1, 1, '2025-02-09 21:28:00', 1, 12, 'Loja Física'),
(12743, 1129, 82, 1, 1, '2025-01-31 17:08:00', 1, 12, 'Bilheteira'),
(12744, 1213, 82, 2, 1, '2025-01-21 16:26:00', 1, 12, 'Bilheteira'),
(12745, 1371, 83, 1, 1, '2025-01-26 19:28:00', 12, 144, 'Online'),
(12746, 1390, 83, 3, 1, '2025-02-19 16:46:00', 1, 12, 'Online'),
(12747, 1396, 81, 4, 1, '2025-02-20 18:35:00', 1, 12, 'Online'),
(12748, 1447, 81, 3, 1, '2025-03-27 10:58:00', 1, 12, 'Loja Física'),
(12749, 1449, 82, 1, 1, '2025-04-15 11:55:00', 1, 12, 'Bilheteira'),
(12750, 1450, 82, 2, 1, '2025-04-19 21:56:00', 1, 12, 'Online'),
(12751, 1504, 83, 5, 1, '2025-04-19 17:40:00', 1, 12, 'Loja Física'),
(12752, 1651, 84, 1, 1, '2025-01-14 15:11:00', 1, 12, 'Loja Física'),
(12753, 1713, 83, 3, 1, '2025-01-02 15:06:00', 12, 144, 'Online'),
(12754, 1756, 82, 1, 1, '2025-02-19 20:21:00', 1, 12, 'Online'),
(12755, 1805, 84, 3, 1, '2025-02-11 16:07:00', 1, 12, 'Bilheteira'),
(12756, 1815, 84, 3, 1, '2025-02-25 10:24:00', 1, 12, 'Bilheteira'),
(12757, 1848, 82, 2, 1, '2025-03-24 19:11:00', 1, 12, 'Bilheteira'),
(12758, 1883, 83, 3, 1, '2025-04-05 19:29:00', 1, 12, 'Online'),
(12759, 1937, 83, 1, 1, '2025-03-11 11:18:00', 1, 12, 'Online'),
(12760, 1945, 81, 3, 1, '2025-04-30 16:17:00', 1, 12, 'Bilheteira'),
(12761, 1001, 85, 6, 2, '2025-01-12 12:14:00', 1, 15, 'Loja Física'),
(12762, 1021, 86, 1, 2, '2025-04-21 14:04:00', 1, 15, 'Online'),
(12763, 1211, 87, 2, 2, '2025-03-24 21:36:00', 1, 15, 'Loja Física'),
(12764, 1302, 88, 2, 2, '2025-04-09 12:42:00', 1, 15, 'Bilheteira'),
(12765, 1442, 87, 6, 2, '2025-03-30 10:26:00', 1, 15, 'Bilheteira'),
(12766, 1461, 85, 6, 2, '2025-02-21 15:02:00', 1, 15, 'Loja Física'),
(12767, 1488, 86, 3, 2, '2025-01-27 19:40:00', 1, 15, 'Desconhecido'),
(12768, 1490, 87, 5, 2, '2025-01-23 21:16:00', 1, 15, 'Online'),
(12769, 1564, 85, 3, 2, '2025-02-03 18:09:00', 1, 15, 'Loja Física'),
(12770, 1676, 85, 2, 2, '2025-02-19 09:05:00', 1, 15, 'Bilheteira'),
(12771, 1752, 85, 3, 2, '2025-03-02 20:49:00', 1, 15, 'Online'),
(12772, 1836, 85, 6, 2, '2025-04-21 10:20:00', 1, 15, 'Bilheteira'),
(12773, 1928, 88, 3, 2, '2025-02-23 16:36:00', 1, 15, 'Loja Física'),
(12774, 1191, 89, 1, 2, '2025-04-12 12:56:00', 1, 18, 'Bilheteira'),
(12775, 1055, 90, 3, 3, '2025-02-01 16:39:00', 1, 18, 'Bilheteira'),
(12776, 1085, 91, 3, 3, '2025-03-12 13:44:00', 1, 18, 'Loja Física'),
(12777, 1223, 92, 5, 3, '2025-01-05 11:45:00', 1, 18, 'Bilheteira'),
(12778, 1258, 93, 6, 2, '2025-01-13 18:02:00', 1, 18, 'Loja Física'),
(12779, 1278, 94, 2, 2, '2025-04-28 10:33:00', 1, 18, 'Online'),
(12780, 1280, 91, 3, 3, '2025-01-12 15:24:00', 1, 18, 'Loja Física'),
(12781, 1281, 95, 5, 2, '2025-03-05 22:27:00', 1, 18, 'Bilheteira'),
(12782, 1344, 92, 6, 3, '2025-03-17 10:00:00', 1, 18, 'Online'),
(12783, 1349, 95, 1, 2, '2025-01-21 16:22:00', 1, 18, 'Loja Física'),
(12784, 1392, 92, 6, 3, '2025-02-07 09:20:00', 1, 18, 'Online'),
(12785, 1448, 96, 1, 3, '2025-04-26 13:41:00', 1, 18, 'Bilheteira'),
(12786, 1535, 89, 3, 2, '2025-01-21 10:17:00', 1, 18, 'Bilheteira'),
(12787, 1715, 96, 5, 3, '2025-04-20 18:08:00', 1, 18, 'Loja Física'),
(12788, 1736, 94, 2, 2, '2025-04-23 16:05:00', 1, 18, 'Online'),
(12789, 1743, 93, 3, 2, '2025-03-04 17:07:00', 1, 18, 'Online'),
(12790, 1748, 89, 1, 2, '2025-04-20 16:29:00', 1, 18, 'Online'),
(12791, 1795, 91, 2, 3, '2025-01-29 11:54:00', 1, 18, 'Online'),
(12792, 1822, 89, 3, 2, '2025-03-10 14:02:00', 1, 18, 'Loja Física'),
(12793, 1866, 93, 2, 2, '2025-01-30 11:02:00', 1, 18, 'Bilheteira'),
(12794, 1900, 90, 2, 3, '2025-02-15 13:22:00', 1, 18, 'Desconhecido'),
(12795, 1934, 92, 2, 3, '2025-03-26 17:11:00', 1, 18, 'Bilheteira'),
(12796, 1942, 94, 2, 2, '2025-02-04 17:37:00', 1, 18, 'Online'),
(12797, 1993, 89, 2, 2, '2025-01-16 10:23:00', 1, 18, 'Loja Física'),
(12798, 1005, 97, 2, 1, '2025-01-06 19:14:00', 1, 22, 'Online'),
(12799, 1024, 98, 2, 2, '2025-02-01 12:12:00', 1, 22, 'Bilheteira'),
(12800, 1054, 99, 2, 2, '2025-04-15 21:15:00', 1, 22, 'Bilheteira'),
(12801, 1071, 100, 3, 2, '2025-03-16 09:59:00', 1, 22, 'Loja Física'),
(12802, 1076, 97, 5, 1, '2025-02-05 16:15:00', 1, 22, 'Loja Física'),
(12803, 1110, 100, 3, 2, '2025-04-22 22:28:00', 1, 22, 'Loja Física'),
(12804, 1172, 98, 3, 2, '2025-02-16 13:11:00', 1, 22, 'Bilheteira'),
(12805, 1226, 98, 5, 2, '2025-03-18 16:16:00', 1, 22, 'Loja Física'),
(12806, 1251, 98, 2, 2, '2025-02-20 13:52:00', 1, 22, 'Loja Física'),
(12807, 1290, 101, 5, 1, '2025-01-24 15:28:00', 1, 22, 'Loja Física'),
(12808, 1314, 100, 2, 2, '2025-01-31 13:07:00', 1, 22, 'Bilheteira'),
(12809, 1361, 100, 1, 2, '2025-01-06 12:57:00', 1, 22, 'Bilheteira'),
(12810, 1414, 101, 5, 1, '2025-02-09 20:32:00', 1, 22, 'Online'),
(12811, 1479, 102, 3, 1, '2025-01-24 11:47:00', 1, 22, 'Online'),
(12812, 1481, 102, 4, 1, '2025-01-20 14:38:00', 1, 22, 'Loja Física'),
(12813, 1542, 98, 2, 2, '2025-03-12 11:30:00', 1, 22, 'Bilheteira'),
(12814, 1620, 102, 6, 1, '2025-02-18 18:57:00', 1, 22, 'Loja Física'),
(12815, 1670, 103, 3, 2, '2025-03-29 22:38:00', 1, 22, 'Bilheteira'),
(12816, 1671, 103, 1, 2, '2025-03-15 21:19:00', 1, 22, 'Online'),
(12817, 1720, 98, 1, 2, '2025-01-05 10:04:00', 1, 22, 'Loja Física'),
(12818, 1827, 99, 2, 2, '2025-03-14 21:33:00', 1, 22, 'Bilheteira'),
(12819, 1851, 97, 5, 1, '2025-02-23 14:11:00', 1, 22, 'Bilheteira'),
(12820, 1953, 97, 2, 3, '2025-04-15 18:40:00', 1, 22, 'Loja Física'),
(12821, 1965, 98, 1, 2, '2025-04-11 11:03:00', 1, 22, 'Online'),
(12822, 1820, 104, 6, 2, '2025-02-24 14:22:00', 1, 25, 'Bilheteira'),
(12823, 1016, 104, 6, 2, '2025-01-15 14:56:00', 1, 25, 'Online'),
(12824, 1074, 105, 2, 2, '2025-02-25 14:40:00', 1, 25, 'Loja Física'),
(12825, 1139, 105, 6, 2, '2025-04-26 10:20:00', 1, 25, 'Online'),
(12826, 1198, 106, 1, 2, '2025-01-17 10:15:00', 1, 25, 'Bilheteira'),
(12827, 1202, 107, 6, 3, '2025-02-27 11:57:00', 1, 25, 'Bilheteira'),
(12828, 1277, 108, 1, 2, '2025-01-03 17:46:00', 1, 25, 'Loja Física'),
(12829, 1331, 108, 6, 2, '2025-01-16 22:10:00', 1, 25, 'Bilheteira'),
(12830, 1372, 108, 3, 2, '2025-01-22 18:27:00', 1, 25, 'Bilheteira'),
(12831, 1389, 104, 1, 2, '2025-02-03 12:15:00', 1, 25, 'Online'),
(12832, 1489, 106, 1, 2, '2025-04-06 19:09:00', 1, 25, 'Bilheteira'),
(12833, 1531, 106, 5, 2, '2025-04-13 10:52:00', 1, 25, 'Bilheteira'),
(12834, 1646, 109, 1, 3, '2025-02-23 13:19:00', 1, 25, 'Bilheteira'),
(12835, 1657, 110, 2, 3, '2025-01-16 09:29:00', 1, 25, 'Online'),
(12836, 1703, 104, 2, 2, '2025-01-17 17:04:00', 1, 25, 'Desconhecido'),
(12837, 1838, 104, 5, 2, '2025-01-31 18:07:00', 1, 25, 'Bilheteira'),
(12838, 1853, 110, 2, 3, '2025-02-21 18:27:00', 1, 25, 'Bilheteira'),
(12839, 1870, 106, 6, 2, '2025-04-24 14:01:00', 1, 25, 'Loja Física'),
(12840, 1882, 105, 1, 2, '2025-03-01 19:46:00', 1, 25, 'Bilheteira'),
(12841, 1956, 109, 1, 3, '2025-03-17 11:47:00', 1, 25, 'Online'),
(12842, 1957, 110, 5, 3, '2025-03-30 19:34:00', 1, 25, 'Bilheteira'),
(12843, 1088, 111, 5, 3, '2025-02-01 10:35:00', 1, 29, 'Loja Física'),
(12844, 1187, 112, 6, 3, '2025-03-09 17:32:00', 1, 29, 'Loja Física'),
(12845, 1472, 111, 5, 3, '2025-04-08 14:35:00', 1, 29, 'Loja Física'),
(12846, 1495, 113, 6, 3, '2025-03-12 22:35:00', 1, 29, 'Online'),
(12847, 1618, 111, 3, 3, '2025-02-13 20:51:00', 1, 29, 'Bilheteira'),
(12848, 1652, 114, 3, 3, '2025-01-12 21:19:00', 1, 29, 'Bilheteira'),
(12849, 1659, 113, 6, 3, '2025-02-09 13:32:00', 1, 29, 'Bilheteira'),
(12850, 1826, 113, 6, 3, '2025-02-08 18:25:00', 1, 29, 'Loja Física'),
(12851, 1954, 114, 5, 3, '2025-02-05 16:57:00', 1, 29, 'Loja Física'),
(12852, 1004, 115, 6, 1, '2025-04-04 16:34:00', 1, 35, 'Bilheteira'),
(12853, 1009, 116, 4, 1, '2025-01-28 18:56:00', 1, 35, 'Bilheteira'),
(12854, 1035, 117, 3, 1, '2025-04-23 12:23:00', 1, 35, 'Online'),
(12855, 1036, 118, 5, 1, '2025-05-01 11:16:00', 1, 35, 'Online'),
(12856, 1120, 115, 5, 1, '2025-04-17 19:25:00', 1, 35, 'Online'),
(12857, 1136, 117, 3, 1, '2025-01-23 13:03:00', 1, 35, 'Loja Física'),
(12858, 1155, 115, 4, 1, '2025-01-01 16:47:00', 1, 35, 'Online'),
(12859, 1220, 116, 1, 1, '2025-02-21 09:36:00', 1, 35, 'Online'),
(12860, 1383, 117, 6, 1, '2025-01-03 11:37:00', 1, 35, 'Online'),
(12861, 1482, 116, 2, 1, '2025-04-11 20:20:00', 1, 35, 'Online'),
(12862, 1691, 118, 1, 1, '2025-01-31 15:44:00', 1, 35, 'Bilheteira'),
(12863, 1704, 115, 2, 1, '2025-04-05 10:38:00', 1, 35, 'Loja Física'),
(12864, 1762, 116, 2, 1, '2025-01-25 16:05:00', 1, 35, 'Bilheteira'),
(12865, 1781, 116, 6, 1, '2025-04-30 18:48:00', 1, 35, 'Online'),
(12866, 1819, 115, 1, 1, '2025-01-04 18:02:00', 1, 35, 'Bilheteira'),
(12867, 1946, 117, 1, 1, '2025-01-21 20:34:00', 1, 35, 'Online'),
(12868, 1068, 119, 6, 1, '2025-04-06 17:03:00', 1, 40, 'Online'),
(12869, 1126, 119, 1, 1, '2025-02-03 17:07:00', 1, 40, 'Bilheteira'),
(12870, 1158, 119, 1, 1, '2025-02-11 11:51:00', 1, 40, 'Bilheteira'),
(12871, 1181, 120, 1, 1, '2025-02-17 12:01:00', 1, 40, 'Online'),
(12872, 1312, 120, 1, 1, '2025-02-03 19:55:00', 1, 40, 'Loja Física'),
(12873, 1397, 119, 3, 1, '2025-02-07 22:42:00', 1, 40, 'Loja Física'),
(12874, 1487, 121, 6, 1, '2025-02-07 19:12:00', 1, 40, 'Loja Física'),
(12875, 1607, 119, 3, 1, '2025-04-10 09:58:00', 1, 40, 'Bilheteira'),
(12876, 1824, 119, 5, 1, '2025-03-30 19:13:00', 1, 40, 'Bilheteira'),
(12877, 1895, 121, 3, 1, '2025-03-05 18:41:00', 1, 40, 'Bilheteira'),
(12878, 1905, 121, 6, 1, '2025-01-20 19:23:00', 1, 40, 'Online'),
(12879, 1982, 120, 2, 1, '2025-01-16 11:56:00', 1, 40, 'Online'),
(12880, 1229, 122, 1, 3, '2025-04-01 11:33:00', 1, 49, 'Loja Física'),
(12881, 1284, 123, 3, 3, '2025-02-08 11:36:00', 1, 49, 'Loja Física'),
(12882, 1369, 124, 6, 3, '2025-04-13 21:08:00', 1, 49, 'Online'),
(12883, 1563, 123, 6, 3, '2025-01-13 10:59:00', 1, 49, 'Loja Física'),
(12884, 1641, 122, 5, 3, '2025-04-03 17:07:00', 1, 49, 'Loja Física'),
(12885, 1645, 122, 2, 3, '2025-04-09 11:58:00', 1, 49, 'Loja Física'),
(12886, 1726, 125, 3, 3, '2025-03-22 20:22:00', 1, 49, 'Online'),
(12887, 1858, 125, 3, 3, '2025-01-02 16:08:00', 1, 49, 'Loja Física'),
(12888, 1906, 122, 1, 3, '2025-02-01 22:51:00', 1, 49, 'Bilheteira'),
(12889, 1920, 122, 2, 3, '2025-01-12 09:27:00', 1, 49, 'Desconhecido'),
(12890, 1964, 124, 6, 3, '2025-03-22 16:37:00', 1, 49, 'Online'),
(12891, 1038, 126, 6, 4, '2025-03-23 15:53:00', 1, 50, 'Online'),
(12892, 1183, 127, 5, 4, '2025-02-02 12:53:00', 1, 50, 'Loja Física'),
(12893, 1197, 126, 2, 4, '2025-03-27 19:25:00', 1, 50, 'Loja Física'),
(12894, 1291, 127, 1, 4, '2025-02-15 17:05:00', 1, 50, 'Loja Física'),
(12895, 1327, 128, 1, 4, '2025-02-21 17:47:00', 1, 50, 'Loja Física'),
(12896, 1334, 127, 2, 4, '2025-01-28 16:04:00', 1, 50, 'Loja Física'),
(12897, 1375, 128, 5, 4, '2025-02-05 15:08:00', 1, 50, 'Online'),
(12898, 1536, 129, 5, 4, '2025-04-28 10:35:00', 1, 50, 'Loja Física'),
(12899, 1583, 129, 5, 4, '2025-03-16 21:44:00', 1, 50, 'Loja Física'),
(12900, 1732, 129, 4, 4, '2025-01-15 16:38:00', 1, 50, 'Online'),
(12901, 1816, 128, 2, 4, '2025-01-23 17:42:00', 1, 50, 'Loja Física'),
(12902, 1966, 127, 6, 4, '2025-03-13 09:18:00', 1, 50, 'Bilheteira'),
(12903, 1241, 130, 1, 4, '2025-02-12 11:46:00', 1, 60, 'Loja Física'),
(12904, 1339, 131, 3, 4, '2025-04-25 10:08:00', 1, 60, 'Loja Física'),
(12905, 1516, 132, 4, 4, '2025-01-17 18:37:00', 1, 60, 'Online'),
(12906, 1525, 130, 5, 4, '2025-04-01 20:50:00', 1, 60, 'Loja Física'),
(12907, 1730, 133, 6, 4, '2025-01-05 20:09:00', 1, 60, 'Loja Física'),
(12908, 1757, 130, 1, 4, '2025-03-21 14:47:00', 1, 60, 'Loja Física'),
(12909, 1784, 131, 3, 4, '2025-04-12 09:09:00', 1, 60, 'Bilheteira'),
(12910, 1807, 130, 3, 4, '2025-03-28 16:43:00', 1, 60, 'Bilheteira'),
(12911, 1192, 134, 6, 4, '2025-04-07 19:12:00', 1, 70, 'Bilheteira'),
(12912, 1114, 135, 1, 4, '2025-01-06 14:50:00', 1, 70, 'Bilheteira'),
(12913, 1156, 135, 6, 4, '2025-02-20 22:47:00', 1, 70, 'Bilheteira'),
(12914, 1243, 134, 3, 4, '2025-02-21 19:06:00', 1, 70, 'Online'),
(12915, 1594, 134, 6, 4, '2025-02-16 12:38:00', 1, 70, 'Online'),
(12916, 1832, 134, 1, 4, '2025-03-23 12:54:00', 1, 70, 'Bilheteira'),
(12917, 1892, 136, 3, 4, '2025-01-14 19:54:00', 1, 70, 'Bilheteira'),
(12918, 1941, 136, 3, 4, '2025-02-10 16:35:00', 1, 70, 'Online'),
(12919, 1145, 137, 5, 4, '2025-02-06 18:19:00', 1, 80, 'Online'),
(12920, 1130, 138, 6, 4, '2025-04-17 16:39:00', 1, 80, 'Bilheteira'),
(12921, 1250, 139, 5, 4, '2025-02-28 11:32:00', 1, 80, 'Bilheteira'),
(12922, 1465, 138, 3, 4, '2025-02-02 18:12:00', 1, 80, 'Online'),
(12923, 1473, 137, 6, 4, '2025-03-08 10:01:00', 1, 80, 'Online'),
(12924, 1540, 139, 2, 4, '2025-02-03 10:24:00', 1, 80, 'Online'),
(12925, 1577, 137, 1, 4, '2025-02-12 10:53:00', 1, 80, 'Online'),
(12926, 1602, 140, 5, 4, '2025-04-03 09:18:00', 1, 80, 'Online'),
(12927, 1649, 140, 1, 4, '2025-03-18 18:00:00', 1, 80, 'Loja Física'),
(12928, 1891, 140, 1, 4, '2025-04-21 16:37:00', 1, 80, 'Online'),
(12929, 1958, 139, 6, 4, '2025-04-20 14:27:00', 1, 80, 'Bilheteira'),
(12930, 1204, 81, 1, 1, '2025-04-12 11:15:00', 2, 24, 'Online'),
(12931, 1763, 83, 2, 1, '2025-02-05 10:44:00', 2, 24, 'Bilheteira'),
(12932, 1779, 82, 1, 1, '2025-04-04 16:47:00', 2, 24, 'Bilheteira'),
(12933, 1040, 87, 5, 2, '2025-03-11 09:53:00', 2, 30, 'Loja Física'),
(12934, 1097, 88, 2, 2, '2025-03-02 17:41:00', 2, 30, 'Bilheteira'),
(12935, 1104, 85, 1, 2, '2025-03-05 20:18:00', 2, 30, 'Loja Física'),
(12936, 1125, 85, 3, 2, '2025-04-07 12:55:00', 2, 30, 'Loja Física'),
(12937, 1148, 88, 1, 2, '2025-02-04 20:48:00', 2, 30, 'Bilheteira'),
(12938, 1159, 85, 3, 2, '2025-02-25 18:25:00', 2, 30, 'Online'),
(12939, 1179, 88, 3, 2, '2025-02-04 16:57:00', 2, 30, 'Online'),
(12940, 1322, 85, 1, 2, '2025-01-27 21:47:00', 2, 30, 'Loja Física'),
(12941, 1517, 86, 5, 2, '2025-02-03 11:33:00', 2, 30, 'Loja Física'),
(12942, 1518, 88, 2, 2, '2025-02-27 18:30:00', 2, 30, 'Online'),
(12943, 1576, 86, 1, 2, '2025-01-02 16:13:00', 2, 30, 'Bilheteira'),
(12944, 1694, 87, 6, 2, '2025-04-03 16:42:00', 2, 30, 'Online'),
(12945, 1706, 88, 3, 2, '2025-03-18 22:09:00', 2, 30, 'Bilheteira'),
(12946, 1813, 85, 1, 2, '2025-02-18 18:43:00', 2, 30, 'Online'),
(12947, 1904, 87, 2, 2, '2025-03-22 10:55:00', 2, 30, 'Bilheteira'),
(12948, 1947, 85, 5, 2, '2025-04-03 17:17:00', 2, 30, 'Online'),
(12949, 1069, 95, 2, 2, '2025-04-18 09:39:00', 2, 36, 'Online'),
(12950, 1090, 95, 2, 2, '2025-02-03 19:05:00', 2, 36, 'Online'),
(12951, 1151, 95, 1, 2, '2025-04-07 18:03:00', 2, 36, 'Online'),
(12952, 1210, 93, 5, 2, '2025-03-26 18:46:00', 2, 36, 'Bilheteira'),
(12953, 1228, 96, 3, 3, '2025-01-03 16:20:00', 2, 36, 'Online'),
(12954, 1275, 94, 5, 2, '2025-01-09 20:09:00', 2, 36, 'Online'),
(12955, 1282, 95, 1, 2, '2025-04-26 22:44:00', 2, 36, 'Bilheteira'),
(12956, 1321, 92, 1, 3, '2025-02-08 22:02:00', 2, 36, 'Bilheteira'),
(12957, 1363, 94, 1, 2, '2025-02-07 13:54:00', 2, 36, 'Bilheteira'),
(12958, 1398, 96, 6, 3, '2025-01-22 19:18:00', 2, 36, 'Bilheteira'),
(12959, 1415, 93, 6, 2, '2025-04-18 09:15:00', 2, 36, 'Bilheteira'),
(12960, 1421, 90, 1, 3, '2025-02-02 18:51:00', 2, 36, 'Loja Física'),
(12961, 1429, 91, 1, 3, '2025-02-15 12:47:00', 2, 36, 'Bilheteira'),
(12962, 1440, 93, 2, 2, '2025-01-28 20:01:00', 2, 36, 'Loja Física'),
(12963, 1553, 92, 5, 3, '2025-02-23 16:08:00', 2, 36, 'Loja Física'),
(12964, 1575, 96, 3, 3, '2025-01-14 13:17:00', 2, 36, 'Loja Física'),
(12965, 1584, 91, 1, 3, '2025-01-21 16:05:00', 2, 36, 'Loja Física'),
(12966, 1593, 90, 5, 3, '2025-01-14 16:12:00', 2, 36, 'Online'),
(12967, 1627, 89, 3, 2, '2025-02-13 15:42:00', 2, 36, 'Online'),
(12968, 1636, 90, 1, 3, '2025-04-29 16:55:00', 2, 36, 'Bilheteira'),
(12969, 1668, 94, 1, 2, '2025-02-13 16:46:00', 2, 36, 'Bilheteira'),
(12970, 1727, 90, 3, 3, '2025-01-04 20:37:00', 2, 36, 'Desconhecido'),
(12971, 1746, 94, 1, 2, '2025-04-29 18:29:00', 2, 36, 'Bilheteira'),
(12972, 1799, 93, 1, 2, '2025-03-27 14:01:00', 2, 36, 'Online'),
(12973, 1803, 92, 5, 3, '2025-04-17 14:24:00', 2, 36, 'Online'),
(12974, 1000, 103, 5, 2, '2025-01-29 11:47:00', 2, 44, 'Loja Física'),
(12975, 1003, 97, 6, 1, '2025-04-08 14:06:00', 2, 44, 'Bilheteira'),
(12976, 1047, 103, 3, 2, '2025-03-16 13:02:00', 2, 44, 'Loja Física'),
(12977, 1061, 101, 2, 1, '2025-01-30 15:44:00', 2, 44, 'Loja Física'),
(12978, 1084, 100, 5, 2, '2025-02-16 11:19:00', 2, 44, 'Loja Física'),
(12979, 1115, 102, 2, 1, '2025-03-09 15:36:00', 2, 44, 'Online'),
(12980, 1133, 103, 5, 2, '2025-01-17 21:36:00', 2, 44, 'Desconhecido'),
(12981, 1207, 141, 5, 1, '2025-02-25 17:58:00', 2, 44, 'Online'),
(12982, 1245, 99, 2, 2, '2025-01-08 19:07:00', 2, 44, 'Bilheteira'),
(12983, 1308, 101, 5, 1, '2025-03-08 11:35:00', 2, 44, 'Bilheteira'),
(12984, 1367, 100, 5, 2, '2025-01-12 20:15:00', 2, 44, 'Bilheteira'),
(12985, 1368, 99, 5, 2, '2025-01-04 15:54:00', 2, 44, 'Loja Física'),
(12986, 1410, 98, 6, 2, '2025-01-07 20:30:00', 2, 44, 'Bilheteira'),
(12987, 1425, 97, 3, 1, '2025-03-08 21:15:00', 2, 44, 'Loja Física'),
(12988, 1427, 100, 1, 2, '2025-03-29 17:40:00', 2, 44, 'Loja Física'),
(12989, 1434, 98, 3, 2, '2025-04-08 21:10:00', 2, 44, 'Online'),
(12990, 1443, 102, 3, 1, '2025-03-30 19:40:00', 2, 44, 'Bilheteira'),
(12991, 1471, 97, 1, 1, '2025-01-27 18:45:00', 2, 44, 'Loja Física'),
(12992, 1474, 100, 1, 2, '2025-02-06 19:16:00', 2, 44, 'Online'),
(12993, 1514, 141, 2, 1, '2025-01-21 14:38:00', 2, 44, 'Online'),
(12994, 1585, 103, 3, 2, '2025-03-31 17:50:00', 2, 44, 'Online'),
(12995, 1631, 100, 3, 2, '2025-04-04 09:48:00', 2, 44, 'Bilheteira'),
(12996, 1633, 141, 3, 1, '2025-03-29 09:22:00', 2, 44, 'Loja Física'),
(12997, 1769, 141, 5, 1, '2025-01-21 12:07:00', 2, 44, 'Bilheteira'),
(12998, 1796, 141, 6, 1, '2025-01-11 15:44:00', 2, 44, 'Online'),
(12999, 1885, 97, 6, 1, '2025-01-24 10:47:00', 2, 44, 'Bilheteira'),
(13000, 1888, 101, 2, 1, '2025-01-02 12:07:00', 2, 44, 'Loja Física'),
(13001, 1896, 100, 2, 2, '2025-03-02 14:28:00', 2, 44, 'Loja Física'),
(13002, 1980, 141, 6, 1, '2025-01-03 11:53:00', 2, 44, 'Online'),
(13003, 1066, 108, 3, 2, '2025-04-21 16:11:00', 2, 50, 'Bilheteira'),
(13004, 1111, 106, 5, 2, '2025-01-10 16:50:00', 2, 50, 'Bilheteira'),
(13005, 1173, 109, 5, 3, '2025-01-10 13:54:00', 2, 50, 'Loja Física'),
(13006, 1208, 110, 1, 3, '2025-02-11 20:14:00', 2, 50, 'Loja Física'),
(13007, 1218, 105, 1, 2, '2025-01-28 18:22:00', 2, 50, 'Online'),
(13008, 1235, 107, 4, 3, '2025-01-07 19:57:00', 2, 50, 'Online'),
(13009, 1253, 104, 3, 2, '2025-04-09 11:49:00', 2, 50, 'Loja Física'),
(13010, 1413, 106, 5, 2, '2025-04-27 22:26:00', 2, 50, 'Bilheteira'),
(13011, 1508, 142, 4, 3, '2025-03-14 18:42:00', 2, 50, 'Loja Física'),
(13012, 1522, 108, 3, 2, '2025-04-26 18:34:00', 2, 50, 'Loja Física'),
(13013, 1526, 108, 6, 2, '2025-03-30 21:20:00', 2, 50, 'Bilheteira'),
(13014, 1530, 106, 5, 2, '2025-01-13 12:32:00', 2, 50, 'Bilheteira'),
(13015, 1544, 109, 6, 3, '2025-04-18 18:22:00', 2, 50, 'Online'),
(13016, 1562, 107, 6, 3, '2025-03-26 13:47:00', 2, 50, 'Loja Física'),
(13017, 1623, 104, 3, 2, '2025-02-18 17:45:00', 2, 50, 'Bilheteira'),
(13018, 1647, 107, 3, 3, '2025-01-01 18:48:00', 2, 50, 'Online'),
(13019, 1650, 107, 6, 3, '2025-01-08 19:22:00', 2, 50, 'Online'),
(13020, 1669, 107, 5, 3, '2025-04-03 09:29:00', 2, 50, 'Loja Física'),
(13021, 1707, 142, 1, 3, '2025-03-15 20:53:00', 2, 50, 'Desconhecido'),
(13022, 1785, 104, 6, 2, '2025-03-04 20:41:00', 2, 50, 'Online'),
(13023, 1830, 106, 5, 2, '2025-03-26 22:47:00', 2, 50, 'Bilheteira'),
(13024, 1879, 104, 5, 2, '2025-03-24 19:45:00', 2, 50, 'Bilheteira'),
(13025, 1889, 106, 2, 2, '2025-03-25 12:27:00', 2, 50, 'Loja Física'),
(13026, 1908, 142, 5, 3, '2025-04-13 15:26:00', 2, 50, 'Bilheteira'),
(13027, 1936, 104, 3, 2, '2025-02-23 09:55:00', 2, 50, 'Bilheteira'),
(13028, 1029, 111, 1, 3, '2025-01-08 18:47:00', 2, 58, 'Online'),
(13029, 1135, 111, 6, 3, '2025-01-15 19:55:00', 2, 58, 'Online'),
(13030, 1161, 113, 2, 3, '2025-01-31 10:09:00', 2, 58, 'Online'),
(13031, 1552, 112, 2, 3, '2025-03-13 15:54:00', 2, 58, 'Online'),
(13032, 1571, 112, 2, 3, '2025-02-22 17:27:00', 2, 58, 'Online'),
(13033, 1634, 114, 2, 3, '2025-04-20 15:31:00', 2, 58, 'Online'),
(13034, 1039, 117, 5, 1, '2025-04-05 16:35:00', 2, 70, 'Bilheteira'),
(13035, 1082, 115, 5, 3, '2025-01-16 20:12:00', 2, 70, 'Online'),
(13036, 1257, 117, 3, 1, '2025-04-30 20:48:00', 2, 70, 'Online'),
(13037, 1319, 118, 3, 1, '2025-03-10 13:10:00', 2, 70, 'Loja Física'),
(13038, 1333, 118, 2, 1, '2025-01-07 15:40:00', 2, 70, 'Desconhecido'),
(13039, 1340, 116, 5, 1, '2025-02-01 13:41:00', 2, 70, 'Online'),
(13040, 1341, 118, 4, 1, '2025-03-08 18:32:00', 2, 70, 'Loja Física'),
(13041, 1364, 116, 2, 1, '2025-01-10 12:08:00', 2, 70, 'Online'),
(13042, 1377, 116, 1, 1, '2025-01-04 14:38:00', 2, 70, 'Online'),
(13043, 1446, 116, 3, 1, '2025-01-06 17:31:00', 2, 70, 'Loja Física'),
(13044, 1537, 115, 6, 1, '2025-03-19 12:29:00', 2, 70, 'Loja Física'),
(13045, 1569, 116, 1, 1, '2025-02-08 09:00:00', 2, 70, 'Online'),
(13046, 1632, 116, 6, 1, '2025-04-10 12:06:00', 2, 70, 'Online'),
(13047, 1794, 115, 1, 1, '2025-04-15 16:56:00', 2, 70, 'Loja Física'),
(13048, 1975, 116, 2, 1, '2025-01-14 16:56:00', 2, 70, 'Bilheteira'),
(13049, 1196, 121, 1, 1, '2025-03-30 16:22:00', 2, 80, 'Online'),
(13050, 1287, 121, 5, 1, '2025-02-15 17:24:00', 2, 80, 'Desconhecido'),
(13051, 1317, 119, 3, 1, '2025-01-25 22:24:00', 2, 80, 'Loja Física'),
(13052, 1329, 119, 1, 1, '2025-02-24 22:13:00', 2, 80, 'Bilheteira'),
(13053, 1393, 120, 5, 1, '2025-04-04 10:35:00', 2, 80, 'Bilheteira'),
(13054, 1470, 143, 5, 1, '2025-01-18 15:38:00', 2, 80, 'Loja Física'),
(13055, 1812, 121, 6, 1, '2025-03-22 11:01:00', 2, 80, 'Loja Física'),
(13056, 1909, 119, 6, 1, '2025-04-09 09:45:00', 2, 80, 'Online'),
(13057, 1910, 143, 2, 1, '2025-02-25 09:25:00', 2, 80, 'Loja Física'),
(13058, 1146, 123, 6, 3, '2025-04-19 10:22:00', 2, 98, 'Bilheteira'),
(13059, 1227, 124, 2, 3, '2025-03-09 19:46:00', 2, 98, 'Bilheteira'),
(13060, 1267, 123, 2, 3, '2025-04-22 14:19:00', 2, 98, 'Online'),
(13061, 1354, 124, 1, 3, '2025-02-11 12:26:00', 2, 98, 'Bilheteira'),
(13062, 1404, 124, 6, 3, '2025-01-22 12:51:00', 2, 98, 'Online'),
(13063, 1579, 122, 6, 3, '2025-04-05 09:12:00', 2, 98, 'Loja Física'),
(13064, 1780, 122, 2, 3, '2025-04-17 18:38:00', 2, 98, 'Online'),
(13065, 1101, 128, 3, 4, '2025-03-08 14:39:00', 2, 100, 'Loja Física'),
(13066, 1127, 126, 5, 4, '2025-03-02 09:39:00', 2, 100, 'Bilheteira'),
(13067, 1206, 128, 5, 4, '2025-02-10 19:04:00', 2, 100, 'Bilheteira'),
(13068, 1409, 128, 3, 4, '2025-02-05 15:09:00', 2, 100, 'Loja Física'),
(13069, 1453, 129, 3, 4, '2025-03-31 20:03:00', 2, 100, 'Online'),
(13070, 1521, 129, 5, 4, '2025-03-02 18:38:00', 2, 100, 'Loja Física'),
(13071, 1533, 126, 5, 4, '2025-03-23 16:28:00', 2, 100, 'Online'),
(13072, 1797, 128, 5, 4, '2025-01-14 09:50:00', 2, 100, 'Loja Física'),
(13073, 1868, 128, 2, 4, '2025-01-16 14:05:00', 2, 100, 'Bilheteira'),
(13074, 1924, 128, 4, 4, '2025-05-01 17:23:00', 2, 100, 'Loja Física'),
(13075, 1940, 127, 3, 4, '2025-01-31 21:38:00', 2, 100, 'Online'),
(13076, 1949, 126, 6, 4, '2025-03-24 09:38:00', 2, 100, 'Online'),
(13077, 1271, 132, 3, 4, '2025-01-03 13:35:00', 2, 120, 'Loja Física'),
(13078, 1323, 133, 1, 4, '2025-04-15 12:51:00', 2, 120, 'Loja Física'),
(13079, 1432, 132, 2, 4, '2025-01-26 14:26:00', 2, 120, 'Bilheteira'),
(13080, 1497, 133, 6, 4, '2025-01-29 18:53:00', 2, 120, 'Online'),
(13081, 1679, 133, 2, 4, '2025-04-21 18:16:00', 2, 120, 'Bilheteira'),
(13082, 1684, 130, 5, 4, '2025-03-26 19:04:00', 2, 120, 'Loja Física'),
(13083, 1731, 132, 6, 4, '2025-01-02 11:40:00', 2, 120, 'Bilheteira'),
(13084, 1738, 131, 3, 4, '2025-03-20 20:02:00', 2, 120, 'Online'),
(13085, 1855, 132, 3, 4, '2025-01-25 22:52:00', 2, 120, 'Bilheteira'),
(13086, 1970, 131, 1, 4, '2025-01-18 21:02:00', 2, 120, 'Online'),
(13087, 1045, 144, 1, 4, '2025-01-29 09:42:00', 2, 140, 'Bilheteira'),
(13088, 1108, 134, 3, 4, '2025-03-31 12:36:00', 2, 140, 'Online'),
(13089, 1184, 136, 5, 4, '2025-02-08 10:03:00', 2, 140, 'Bilheteira'),
(13090, 1230, 134, 1, 4, '2025-02-28 17:21:00', 2, 140, 'Bilheteira'),
(13091, 1233, 134, 1, 4, '2025-02-07 09:18:00', 2, 140, 'Online'),
(13092, 1288, 136, 3, 4, '2025-04-02 10:05:00', 2, 140, 'Online'),
(13093, 1357, 136, 5, 4, '2025-02-07 18:50:00', 2, 140, 'Loja Física'),
(13094, 1619, 136, 5, 4, '2025-04-05 17:13:00', 2, 140, 'Loja Física'),
(13095, 1914, 135, 1, 4, '2025-01-12 17:35:00', 2, 140, 'Loja Física'),
(13096, 1010, 140, 5, 4, '2025-02-03 11:15:00', 2, 160, 'Loja Física'),
(13097, 1105, 140, 5, 4, '2025-02-28 17:09:00', 2, 160, 'Online'),
(13098, 1234, 137, 4, 4, '2025-01-26 22:34:00', 2, 160, 'Loja Física'),
(13099, 1394, 139, 1, 4, '2025-03-19 15:10:00', 2, 160, 'Online'),
(13100, 1405, 139, 1, 4, '2025-04-16 19:09:00', 2, 160, 'Bilheteira'),
(13101, 1546, 137, 5, 4, '2025-04-08 17:17:00', 2, 160, 'Online'),
(13102, 1578, 139, 6, 4, '2025-01-25 22:16:00', 2, 160, 'Online'),
(13103, 1611, 137, 6, 4, '2025-01-17 14:05:00', 2, 160, 'Loja Física'),
(13104, 1666, 139, 5, 4, '2025-02-17 16:53:00', 2, 160, 'Desconhecido'),
(13105, 1721, 139, 3, 4, '2025-03-25 19:00:00', 2, 160, 'Loja Física'),
(13106, 1782, 137, 2, 4, '2025-03-13 16:45:00', 2, 160, 'Online'),
(13107, 1839, 138, 3, 4, '2025-01-19 10:11:00', 2, 160, 'Bilheteira'),
(13108, 1856, 138, 2, 4, '2025-03-18 12:52:00', 2, 160, 'Loja Física'),
(13109, 1857, 138, 3, 4, '2025-01-04 13:16:00', 2, 160, 'Loja Física'),
(13110, 1913, 137, 1, 4, '2025-04-23 13:05:00', 2, 160, 'Loja Física'),
(13111, 1977, 138, 1, 4, '2025-04-16 09:23:00', 2, 160, 'Online'),
(13112, 1050, 82, 1, 1, '2025-03-21 14:42:00', 3, 36, 'Loja Física'),
(13113, 1153, 82, 1, 1, '2025-03-28 19:37:00', 3, 36, 'Loja Física'),
(13114, 1193, 84, 1, 1, '2025-02-25 15:47:00', 3, 36, 'Bilheteira'),
(13115, 1244, 81, 1, 1, '2025-02-19 12:28:00', 3, 36, 'Bilheteira'),
(13116, 1347, 82, 2, 1, '2025-03-31 15:46:00', 3, 36, 'Desconhecido'),
(13117, 1621, 81, 6, 1, '2025-01-26 21:44:00', 3, 36, 'Bilheteira'),
(13118, 1667, 81, 3, 1, '2025-04-11 09:49:00', 3, 36, 'Online'),
(13119, 1787, 82, 2, 1, '2025-03-07 20:36:00', 3, 36, 'Bilheteira'),
(13120, 1835, 81, 2, 1, '2025-04-12 21:17:00', 3, 36, 'Loja Física'),
(13121, 1164, 88, 1, 2, '2025-03-01 16:02:00', 3, 45, 'Bilheteira'),
(13122, 1266, 86, 6, 2, '2025-02-18 19:38:00', 3, 45, 'Desconhecido'),
(13123, 1496, 85, 2, 2, '2025-01-27 20:47:00', 3, 45, 'Bilheteira'),
(13124, 1653, 85, 1, 2, '2025-03-02 11:07:00', 3, 45, 'Bilheteira'),
(13125, 1682, 88, 2, 2, '2025-03-10 16:25:00', 3, 45, 'Bilheteira'),
(13126, 1798, 85, 6, 2, '2025-01-06 10:19:00', 3, 45, 'Online'),
(13127, 1951, 85, 3, 2, '2025-04-15 15:52:00', 3, 45, 'Bilheteira'),
(13128, 1103, 93, 2, 2, '2025-03-12 09:35:00', 3, 54, 'Online'),
(13129, 1113, 95, 6, 2, '2025-01-30 20:05:00', 3, 54, 'Online'),
(13130, 1182, 90, 3, 3, '2025-04-28 22:30:00', 3, 54, 'Online'),
(13131, 1325, 92, 2, 3, '2025-04-21 19:08:00', 3, 54, 'Online'),
(13132, 1346, 91, 5, 3, '2025-01-11 17:58:00', 3, 54, 'Online'),
(13133, 1352, 94, 6, 2, '2025-01-21 13:49:00', 3, 54, 'Loja Física'),
(13134, 1388, 94, 2, 2, '2025-04-06 10:15:00', 3, 54, 'Bilheteira'),
(13135, 1436, 91, 6, 3, '2025-04-07 22:33:00', 3, 54, 'Online'),
(13136, 1438, 96, 5, 3, '2025-02-07 16:46:00', 3, 54, 'Loja Física'),
(13137, 1524, 94, 5, 2, '2025-03-03 21:14:00', 3, 54, 'Bilheteira'),
(13138, 1603, 91, 1, 3, '2025-01-29 12:54:00', 3, 54, 'Online'),
(13139, 1614, 90, 6, 3, '2025-04-10 15:20:00', 3, 54, 'Loja Física'),
(13140, 1617, 93, 6, 2, '2025-01-20 21:46:00', 3, 54, 'Online'),
(13141, 1690, 91, 5, 3, '2025-04-26 17:03:00', 3, 54, 'Loja Física'),
(13142, 1759, 93, 5, 2, '2025-01-31 17:07:00', 3, 54, 'Bilheteira'),
(13143, 1776, 93, 6, 2, '2025-01-26 09:05:00', 3, 54, 'Bilheteira'),
(13144, 1804, 92, 3, 3, '2025-01-16 16:07:00', 3, 54, 'Online'),
(13145, 1809, 89, 2, 2, '2025-01-26 18:54:00', 3, 54, 'Online'),
(13146, 1849, 94, 2, 2, '2025-02-10 18:05:00', 3, 54, 'Online'),
(13147, 1873, 90, 5, 3, '2025-02-11 21:03:00', 3, 54, 'Online'),
(13148, 1978, 95, 6, 2, '2025-02-26 12:40:00', 3, 54, 'Bilheteira'),
(13149, 1979, 93, 2, 2, '2025-01-23 12:56:00', 3, 54, 'Loja Física'),
(13150, 1981, 92, 1, 3, '2025-04-30 12:19:00', 3, 54, 'Online'),
(13151, 1992, 91, 5, 3, '2025-04-26 10:18:00', 3, 54, 'Loja Física'),
(13152, 1995, 91, 5, 3, '2025-02-06 22:22:00', 3, 54, 'Bilheteira'),
(13153, 1100, 99, 5, 2, '2025-01-15 21:25:00', 3, 66, 'Online'),
(13154, 1124, 97, 1, 1, '2025-04-27 22:30:00', 3, 66, 'Loja Física'),
(13155, 1160, 97, 6, 1, '2025-04-10 11:04:00', 3, 66, 'Loja Física'),
(13156, 1272, 141, 5, 1, '2025-01-30 15:36:00', 3, 66, 'Bilheteira'),
(13157, 1343, 103, 1, 2, '2025-01-17 15:55:00', 3, 66, 'Bilheteira'),
(13158, 1418, 97, 6, 1, '2025-04-06 22:44:00', 3, 66, 'Bilheteira'),
(13159, 1428, 141, 5, 1, '2025-01-13 16:08:00', 3, 66, 'Bilheteira'),
(13160, 1439, 102, 3, 1, '2025-04-26 16:22:00', 3, 66, 'Online'),
(13161, 1502, 97, 1, 1, '2025-04-23 16:29:00', 3, 66, 'Bilheteira'),
(13162, 1565, 141, 2, 1, '2025-02-26 19:08:00', 3, 66, 'Loja Física'),
(13163, 1566, 103, 5, 2, '2025-04-21 16:29:00', 3, 66, 'Bilheteira'),
(13164, 1673, 141, 6, 1, '2025-01-15 09:39:00', 3, 66, 'Loja Física'),
(13165, 1744, 102, 4, 1, '2025-01-30 21:07:00', 3, 66, 'Online'),
(13166, 1761, 103, 3, 2, '2025-02-27 16:32:00', 3, 66, 'Online'),
(13167, 1768, 101, 5, 1, '2025-02-06 16:10:00', 3, 66, 'Online'),
(13168, 1863, 102, 1, 1, '2025-01-15 14:02:00', 3, 66, 'Bilheteira'),
(13169, 1897, 102, 1, 1, '2025-04-03 20:24:00', 3, 66, 'Loja Física'),
(13170, 1916, 103, 6, 2, '2025-03-22 17:22:00', 3, 66, 'Online'),
(13171, 1999, 98, 5, 2, '2025-01-29 15:27:00', 3, 66, 'Bilheteira'),
(13172, 1023, 108, 6, 2, '2025-02-24 15:29:00', 3, 75, 'Online'),
(13173, 1033, 110, 4, 3, '2025-02-20 11:42:00', 3, 75, 'Bilheteira'),
(13174, 1062, 105, 3, 2, '2025-03-11 16:26:00', 3, 75, 'Online'),
(13175, 1064, 142, 3, 3, '2025-02-25 16:01:00', 3, 75, 'Bilheteira'),
(13176, 1134, 109, 1, 3, '2025-04-10 11:50:00', 3, 75, 'Desconhecido'),
(13177, 1180, 106, 5, 2, '2025-04-30 09:26:00', 3, 75, 'Bilheteira'),
(13178, 1236, 108, 6, 2, '2025-04-02 16:06:00', 3, 75, 'Online'),
(13179, 1249, 109, 2, 3, '2025-04-20 17:28:00', 3, 75, 'Loja Física'),
(13180, 1252, 108, 3, 2, '2025-03-31 10:34:00', 3, 75, 'Online'),
(13181, 1265, 142, 1, 3, '2025-01-27 14:41:00', 3, 75, 'Desconhecido'),
(13182, 1307, 105, 6, 2, '2025-01-09 13:02:00', 3, 75, 'Online'),
(13183, 1350, 110, 3, 3, '2025-04-04 10:49:00', 3, 75, 'Bilheteira'),
(13184, 1466, 142, 5, 3, '2025-01-14 21:26:00', 3, 75, 'Loja Física'),
(13185, 1555, 107, 1, 3, '2025-03-02 22:40:00', 3, 75, 'Bilheteira'),
(13186, 1560, 110, 5, 3, '2025-02-10 19:18:00', 3, 75, 'Bilheteira'),
(13187, 1574, 105, 6, 2, '2025-03-31 18:31:00', 3, 75, 'Bilheteira'),
(13188, 1581, 104, 2, 2, '2025-01-26 14:56:00', 3, 75, 'Loja Física'),
(13189, 1582, 106, 6, 2, '2025-01-02 11:50:00', 3, 75, 'Loja Física'),
(13190, 1589, 106, 6, 2, '2025-04-15 13:34:00', 3, 75, 'Bilheteira'),
(13191, 1615, 105, 6, 2, '2025-02-14 12:20:00', 3, 75, 'Loja Física'),
(13192, 1644, 108, 5, 2, '2025-01-11 17:45:00', 3, 75, 'Loja Física'),
(13193, 1716, 107, 3, 3, '2025-02-07 16:42:00', 3, 75, 'Loja Física'),
(13194, 1747, 142, 5, 3, '2025-02-04 12:21:00', 3, 75, 'Online'),
(13195, 1758, 108, 2, 2, '2025-03-01 18:02:00', 3, 75, 'Bilheteira'),
(13196, 1821, 109, 1, 3, '2025-03-17 10:58:00', 3, 75, 'Online'),
(13197, 1861, 104, 6, 2, '2025-02-20 19:23:00', 3, 75, 'Loja Física'),
(13198, 1884, 108, 3, 2, '2025-02-10 18:46:00', 3, 75, 'Loja Física'),
(13199, 1984, 110, 5, 3, '2025-02-01 09:40:00', 3, 75, 'Online'),
(13200, 1123, 112, 5, 3, '2025-04-06 15:11:00', 3, 87, 'Online'),
(13201, 1242, 112, 5, 3, '2025-03-14 19:48:00', 3, 87, 'Online'),
(13202, 1289, 114, 1, 3, '2025-01-14 10:00:00', 3, 87, 'Bilheteira'),
(13203, 1437, 111, 1, 3, '2025-01-17 10:24:00', 3, 87, 'Loja Física'),
(13204, 1499, 114, 1, 3, '2025-01-17 19:41:00', 3, 87, 'Online'),
(13205, 1527, 114, 5, 3, '2025-04-20 17:27:00', 3, 87, 'Bilheteira'),
(13206, 1588, 111, 2, 3, '2025-04-04 16:17:00', 3, 87, 'Loja Física'),
(13207, 1605, 111, 6, 3, '2025-01-12 18:25:00', 3, 87, 'Online'),
(13208, 1672, 111, 6, 3, '2025-03-10 14:49:00', 3, 87, 'Loja Física'),
(13209, 1674, 113, 2, 3, '2025-01-19 20:51:00', 3, 87, 'Loja Física'),
(13210, 1754, 111, 1, 3, '2025-01-31 19:05:00', 3, 87, 'Bilheteira'),
(13211, 1760, 111, 1, 3, '2025-04-25 13:32:00', 3, 87, 'Bilheteira'),
(13212, 1770, 114, 1, 3, '2025-01-24 12:35:00', 3, 87, 'Online'),
(13213, 1907, 112, 2, 3, '2025-04-02 21:26:00', 3, 87, 'Loja Física'),
(13214, 1918, 113, 2, 3, '2025-03-27 21:52:00', 3, 87, 'Loja Física'),
(13215, 1046, 118, 1, 1, '2025-03-24 17:25:00', 3, 105, 'Loja Física'),
(13216, 1200, 116, 3, 1, '2025-02-01 10:01:00', 3, 105, 'Online'),
(13217, 1214, 117, 1, 1, '2025-04-04 22:22:00', 3, 105, 'Online'),
(13218, 1240, 118, 2, 1, '2025-02-28 19:34:00', 3, 105, 'Bilheteira'),
(13219, 1324, 117, 6, 1, '2025-02-07 18:17:00', 3, 105, 'Loja Física'),
(13220, 1411, 115, 6, 1, '2025-04-18 16:54:00', 3, 105, 'Loja Física'),
(13221, 1416, 117, 6, 1, '2025-04-16 16:32:00', 3, 105, 'Loja Física'),
(13222, 1493, 118, 3, 1, '2025-03-19 10:18:00', 3, 105, 'Bilheteira'),
(13223, 1554, 116, 6, 1, '2025-03-13 22:36:00', 3, 105, 'Bilheteira'),
(13224, 1701, 116, 1, 1, '2025-02-07 11:02:00', 3, 105, 'Loja Física'),
(13225, 1714, 117, 6, 1, '2025-01-25 09:01:00', 3, 105, 'Online'),
(13226, 1717, 116, 3, 1, '2025-01-21 21:04:00', 3, 105, 'Online'),
(13227, 1825, 117, 5, 1, '2025-02-25 12:31:00', 3, 105, 'Online'),
(13228, 1843, 116, 2, 1, '2025-04-26 21:43:00', 3, 105, 'Desconhecido'),
(13229, 1864, 116, 1, 1, '2025-03-20 22:48:00', 3, 105, 'Loja Física'),
(13230, 1926, 115, 5, 1, '2025-03-04 09:50:00', 3, 105, 'Online'),
(13231, 1972, 115, 2, 1, '2025-01-02 17:37:00', 3, 105, 'Loja Física'),
(13232, 1994, 117, 2, 1, '2025-02-08 20:52:00', 3, 105, 'Bilheteira'),
(13233, 1011, 121, 6, 1, '2025-01-29 11:32:00', 3, 120, 'Online'),
(13234, 1067, 120, 3, 1, '2025-02-13 21:56:00', 3, 120, 'Bilheteira'),
(13235, 1132, 119, 2, 1, '2025-01-25 10:54:00', 3, 120, 'Desconhecido'),
(13236, 1360, 119, 3, 1, '2025-01-14 12:33:00', 3, 120, 'Bilheteira'),
(13237, 1592, 143, 6, 1, '2025-01-15 10:33:00', 3, 120, 'Online'),
(13238, 1689, 143, 3, 1, '2025-01-12 18:00:00', 3, 120, 'Loja Física'),
(13239, 1725, 119, 3, 1, '2025-03-24 12:11:00', 3, 120, 'Online'),
(13240, 1773, 143, 5, 1, '2025-05-01 21:36:00', 3, 120, 'Online'),
(13241, 1789, 143, 6, 1, '2025-01-07 13:18:00', 3, 120, 'Desconhecido'),
(13242, 1860, 120, 6, 1, '2025-03-19 19:51:00', 3, 120, 'Loja Física'),
(13243, 1876, 121, 6, 1, '2025-04-26 19:38:00', 3, 120, 'Bilheteira'),
(13244, 1881, 120, 5, 1, '2025-03-14 09:35:00', 3, 120, 'Online'),
(13245, 1960, 121, 5, 1, '2025-01-01 15:12:00', 3, 120, 'Online'),
(13246, 1118, 124, 1, 3, '2025-03-17 13:40:00', 3, 147, 'Loja Física'),
(13247, 1128, 124, 6, 3, '2025-03-25 15:07:00', 3, 147, 'Online'),
(13248, 1194, 122, 3, 3, '2025-04-29 21:33:00', 3, 147, 'Online'),
(13249, 1261, 123, 2, 3, '2025-02-05 09:35:00', 3, 147, 'Loja Física'),
(13250, 1298, 125, 5, 3, '2025-04-15 21:25:00', 3, 147, 'Online'),
(13251, 1316, 123, 6, 3, '2025-01-18 11:20:00', 3, 147, 'Loja Física'),
(13252, 1376, 124, 5, 3, '2025-03-03 17:50:00', 3, 147, 'Bilheteira'),
(13253, 1385, 122, 1, 3, '2025-01-23 20:35:00', 3, 147, 'Loja Física'),
(13254, 1386, 123, 6, 3, '2025-04-04 20:18:00', 3, 147, 'Online'),
(13255, 1580, 122, 6, 3, '2025-04-30 14:10:00', 3, 147, 'Loja Física'),
(13256, 1642, 122, 2, 3, '2025-02-27 09:11:00', 3, 147, 'Loja Física'),
(13257, 1829, 122, 2, 3, '2025-03-21 17:29:00', 3, 147, 'Loja Física'),
(13258, 1845, 123, 6, 3, '2025-04-23 21:49:00', 3, 147, 'Bilheteira'),
(13259, 1997, 122, 3, 3, '2025-04-12 10:20:00', 3, 147, 'Bilheteira'),
(13260, 1080, 127, 5, 4, '2025-01-29 15:44:00', 3, 150, 'Bilheteira'),
(13261, 1246, 126, 3, 4, '2025-02-17 18:14:00', 3, 150, 'Online'),
(13262, 1262, 128, 1, 4, '2025-05-01 19:42:00', 3, 150, 'Loja Física'),
(13263, 1313, 128, 1, 4, '2025-02-15 22:29:00', 3, 150, 'Online'),
(13264, 1335, 127, 2, 4, '2025-04-15 10:55:00', 3, 150, 'Loja Física'),
(13265, 1532, 127, 3, 4, '2025-01-29 14:05:00', 3, 150, 'Desconhecido'),
(13266, 1658, 128, 6, 4, '2025-02-14 17:51:00', 3, 150, 'Online'),
(13267, 1665, 129, 1, 4, '2025-04-01 22:20:00', 3, 150, 'Online'),
(13268, 1718, 126, 3, 4, '2025-04-15 13:11:00', 3, 150, 'Online'),
(13269, 1765, 128, 4, 4, '2025-01-25 10:01:00', 3, 150, 'Loja Física'),
(13270, 1871, 126, 3, 4, '2025-01-20 09:05:00', 3, 150, 'Loja Física'),
(13271, 1872, 126, 5, 4, '2025-01-06 19:39:00', 3, 150, 'Bilheteira'),
(13272, 1919, 129, 6, 4, '2025-03-08 18:12:00', 3, 150, 'Bilheteira'),
(13273, 1224, 133, 5, 4, '2025-04-30 18:20:00', 3, 180, 'Bilheteira'),
(13274, 1231, 133, 2, 4, '2025-03-13 13:14:00', 3, 180, 'Bilheteira'),
(13275, 1263, 131, 2, 4, '2025-02-18 11:48:00', 3, 180, 'Bilheteira'),
(13276, 1300, 131, 3, 4, '2025-01-31 13:42:00', 3, 180, 'Loja Física'),
(13277, 1332, 133, 1, 4, '2025-01-21 22:59:00', 3, 180, 'Online'),
(13278, 1401, 130, 6, 4, '2025-03-14 09:09:00', 3, 180, 'Loja Física'),
(13279, 1572, 131, 5, 4, '2025-01-11 15:40:00', 3, 180, 'Loja Física'),
(13280, 1705, 130, 5, 4, '2025-04-11 20:15:00', 3, 180, 'Online'),
(13281, 1767, 130, 1, 4, '2025-01-22 21:16:00', 3, 180, 'Bilheteira'),
(13282, 1817, 131, 3, 4, '2025-04-02 15:31:00', 3, 180, 'Loja Física'),
(13283, 1831, 132, 1, 4, '2025-03-01 11:15:00', 3, 180, 'Loja Física'),
(13284, 1841, 131, 3, 4, '2025-04-23 21:59:00', 3, 180, 'Bilheteira'),
(13285, 1898, 133, 2, 4, '2025-03-30 20:05:00', 3, 180, 'Bilheteira'),
(13286, 1930, 131, 3, 4, '2025-01-12 21:39:00', 3, 180, 'Desconhecido'),
(13287, 1201, 136, 3, 4, '2025-04-01 16:13:00', 3, 210, 'Bilheteira'),
(13288, 1549, 136, 1, 4, '2025-03-20 22:16:00', 3, 210, 'Loja Física'),
(13289, 1643, 136, 6, 4, '2025-03-30 19:58:00', 3, 210, 'Online'),
(13290, 1677, 144, 6, 4, '2025-04-15 12:45:00', 3, 210, 'Loja Física'),
(13291, 1681, 135, 4, 4, '2025-03-19 18:08:00', 3, 210, 'Online'),
(13292, 1711, 144, 5, 4, '2025-02-04 21:06:00', 3, 210, 'Loja Física'),
(13293, 1902, 144, 2, 4, '2025-04-09 09:49:00', 3, 210, 'Bilheteira'),
(13294, 1927, 136, 6, 4, '2025-01-28 11:52:00', 3, 210, 'Bilheteira'),
(13295, 1989, 135, 3, 4, '2025-03-12 10:08:00', 3, 210, 'Bilheteira'),
(13296, 1095, 137, 5, 4, '2025-03-06 17:31:00', 3, 240, 'Online'),
(13297, 1117, 137, 5, 4, '2025-03-27 09:57:00', 3, 240, 'Bilheteira'),
(13298, 1232, 137, 6, 4, '2025-03-13 21:46:00', 3, 240, 'Bilheteira'),
(13299, 1296, 137, 2, 4, '2025-02-25 22:52:00', 3, 240, 'Loja Física'),
(13300, 1356, 139, 5, 4, '2025-04-10 22:19:00', 3, 240, 'Online'),
(13301, 1366, 137, 1, 4, '2025-04-20 10:05:00', 3, 240, 'Desconhecido'),
(13302, 1403, 138, 5, 4, '2025-01-11 15:57:00', 3, 240, 'Online'),
(13303, 1477, 140, 2, 4, '2025-03-12 09:00:00', 3, 240, 'Bilheteira'),
(13304, 1561, 137, 2, 4, '2025-04-06 18:33:00', 3, 240, 'Bilheteira'),
(13305, 1685, 139, 1, 4, '2025-03-13 10:52:00', 3, 240, 'Online'),
(13306, 1696, 140, 5, 4, '2025-01-29 11:27:00', 3, 240, 'Online'),
(13307, 1777, 138, 1, 4, '2025-03-19 18:32:00', 3, 240, 'Loja Física'),
(13308, 1778, 138, 1, 4, '2025-02-19 14:00:00', 3, 240, 'Bilheteira'),
(13309, 1874, 139, 6, 4, '2025-01-23 12:49:00', 3, 240, 'Online'),
(13310, 1878, 139, 6, 4, '2025-03-20 11:27:00', 3, 240, 'Bilheteira'),
(13311, 1931, 138, 1, 4, '2025-03-11 09:42:00', 3, 240, 'Loja Física'),
(13312, 1987, 140, 6, 4, '2025-03-16 15:40:00', 3, 240, 'Loja Física'),
(13313, 1034, 83, 2, 1, '2025-03-21 18:06:00', 4, 48, 'Loja Física'),
(13314, 1044, 81, 2, 1, '2025-04-22 09:54:00', 4, 48, 'Online'),
(13315, 1424, 84, 1, 1, '2025-01-09 14:17:00', 4, 48, 'Bilheteira'),
(13316, 1426, 81, 3, 1, '2025-02-07 13:58:00', 4, 48, 'Desconhecido'),
(13317, 1433, 81, 6, 1, '2025-02-12 19:11:00', 4, 48, 'Loja Física'),
(13318, 1445, 83, 2, 1, '2025-01-26 18:12:00', 4, 48, 'Loja Física'),
(13319, 1452, 81, 3, 1, '2025-02-21 16:17:00', 4, 48, 'Desconhecido'),
(13320, 1486, 82, 5, 1, '2025-02-02 17:46:00', 4, 48, 'Online'),
(13321, 1570, 82, 1, 1, '2025-04-07 16:19:00', 4, 48, 'Bilheteira'),
(13322, 1963, 81, 5, 1, '2025-01-31 14:53:00', 4, 48, 'Bilheteira'),
(13323, 1990, 81, 3, 1, '2025-03-07 18:21:00', 4, 48, 'Bilheteira'),
(13324, 1091, 86, 6, 2, '2025-02-27 20:38:00', 4, 60, 'Bilheteira'),
(13325, 1222, 86, 2, 2, '2025-02-17 21:21:00', 4, 60, 'Bilheteira'),
(13326, 1348, 85, 2, 2, '2025-03-20 18:03:00', 4, 60, 'Loja Física'),
(13327, 1407, 85, 6, 2, '2025-01-20 11:36:00', 4, 60, 'Loja Física'),
(13328, 1441, 88, 6, 2, '2025-04-23 19:16:00', 4, 60, 'Loja Física'),
(13329, 1729, 88, 5, 2, '2025-01-16 12:51:00', 4, 60, 'Loja Física'),
(13330, 1962, 87, 1, 2, '2025-02-25 21:01:00', 4, 60, 'Loja Física'),
(13331, 1968, 88, 6, 2, '2025-03-08 14:37:00', 4, 60, 'Desconhecido'),
(13332, 1973, 86, 6, 2, '2025-02-14 12:12:00', 4, 60, 'Online'),
(13333, 1012, 93, 3, 2, '2025-03-18 10:24:00', 4, 72, 'Loja Física'),
(13334, 1017, 96, 4, 3, '2025-04-15 10:48:00', 4, 72, 'Online'),
(13335, 1032, 96, 4, 3, '2025-03-26 18:36:00', 4, 72, 'Bilheteira'),
(13336, 1175, 92, 5, 3, '2025-02-16 19:46:00', 4, 72, 'Bilheteira'),
(13337, 1178, 91, 5, 3, '2025-04-22 14:35:00', 4, 72, 'Loja Física'),
(13338, 1215, 89, 6, 2, '2025-01-16 13:28:00', 4, 72, 'Online'),
(13339, 1299, 90, 6, 3, '2025-05-01 20:13:00', 4, 72, 'Bilheteira'),
(13340, 1305, 91, 2, 3, '2025-01-14 13:26:00', 4, 72, 'Online'),
(13341, 1338, 95, 2, 2, '2025-02-14 20:13:00', 4, 72, 'Loja Física'),
(13342, 1359, 90, 6, 3, '2025-01-04 12:34:00', 4, 72, 'Loja Física'),
(13343, 1444, 89, 6, 2, '2025-04-17 10:32:00', 4, 72, 'Loja Física'),
(13344, 1462, 89, 3, 2, '2025-02-13 14:52:00', 4, 72, 'Online'),
(13345, 1587, 91, 3, 3, '2025-04-01 16:35:00', 4, 72, 'Loja Física'),
(13346, 1595, 92, 3, 3, '2025-04-13 19:03:00', 4, 72, 'Loja Física'),
(13347, 1604, 96, 5, 3, '2025-02-15 11:08:00', 4, 72, 'Bilheteira'),
(13348, 1635, 90, 2, 3, '2025-04-08 09:59:00', 4, 72, 'Bilheteira'),
(13349, 1708, 95, 5, 2, '2025-02-21 16:19:00', 4, 72, 'Loja Física'),
(13350, 1740, 89, 6, 2, '2025-04-09 19:42:00', 4, 72, 'Bilheteira'),
(13351, 1755, 92, 2, 3, '2025-03-01 21:08:00', 4, 72, 'Bilheteira'),
(13352, 1793, 90, 3, 3, '2025-02-28 10:07:00', 4, 72, 'Online'),
(13353, 1808, 95, 2, 2, '2025-02-21 20:37:00', 4, 72, 'Loja Física'),
(13354, 1952, 96, 6, 3, '2025-02-17 12:28:00', 4, 72, 'Online'),
(13355, 1976, 93, 1, 2, '2025-03-21 12:15:00', 4, 72, 'Loja Física'),
(13356, 1996, 94, 3, 2, '2025-01-30 12:46:00', 4, 72, 'Online'),
(13357, 1006, 98, 1, 2, '2025-03-23 22:23:00', 4, 88, 'Bilheteira'),
(13358, 1014, 102, 5, 1, '2025-01-01 20:56:00', 4, 88, 'Bilheteira'),
(13359, 1086, 103, 1, 2, '2025-03-03 16:21:00', 4, 88, 'Online'),
(13360, 1107, 102, 5, 1, '2025-03-10 16:22:00', 4, 88, 'Loja Física'),
(13361, 1143, 97, 3, 1, '2025-01-09 10:53:00', 4, 88, 'Online'),
(13362, 1163, 97, 1, 1, '2025-01-09 16:28:00', 4, 88, 'Bilheteira'),
(13363, 1217, 141, 6, 1, '2025-03-07 16:31:00', 4, 88, 'Bilheteira'),
(13364, 1297, 97, 3, 1, '2025-02-10 11:25:00', 4, 88, 'Bilheteira'),
(13365, 1303, 98, 5, 2, '2025-01-14 09:06:00', 4, 88, 'Online'),
(13366, 1337, 97, 2, 1, '2025-04-10 22:48:00', 4, 88, 'Loja Física'),
(13367, 1342, 101, 5, 1, '2025-02-19 10:15:00', 4, 88, 'Loja Física'),
(13368, 1417, 100, 5, 2, '2025-03-18 16:11:00', 4, 88, 'Loja Física'),
(13369, 1485, 103, 6, 2, '2025-01-31 19:39:00', 4, 88, 'Online'),
(13370, 1500, 100, 5, 2, '2025-02-27 14:39:00', 4, 88, 'Bilheteira'),
(13371, 1509, 101, 6, 1, '2025-01-30 10:16:00', 4, 88, 'Online'),
(13372, 1528, 102, 1, 1, '2025-03-12 21:35:00', 4, 88, 'Online'),
(13373, 1539, 99, 3, 2, '2025-02-18 18:30:00', 4, 88, 'Bilheteira'),
(13374, 1543, 141, 1, 1, '2025-04-05 12:15:00', 4, 88, 'Online'),
(13375, 1601, 141, 1, 1, '2025-04-09 17:59:00', 4, 88, 'Bilheteira'),
(13376, 1606, 102, 5, 1, '2025-04-16 20:44:00', 4, 88, 'Online'),
(13377, 1655, 98, 5, 2, '2025-03-19 22:20:00', 4, 88, 'Loja Física'),
(13378, 1660, 99, 2, 2, '2025-04-03 18:39:00', 4, 88, 'Online'),
(13379, 1739, 99, 5, 2, '2025-01-01 17:15:00', 4, 88, 'Online'),
(13380, 1742, 97, 6, 1, '2025-02-02 14:39:00', 4, 88, 'Online'),
(13381, 1788, 100, 6, 2, '2025-04-23 20:08:00', 4, 88, 'Online'),
(13382, 1901, 103, 2, 2, '2025-01-15 18:14:00', 4, 88, 'Loja Física'),
(13383, 1938, 100, 2, 2, '2025-03-28 11:03:00', 4, 88, 'Bilheteira'),
(13384, 1939, 103, 1, 2, '2025-01-13 14:09:00', 4, 88, 'Bilheteira'),
(13385, 1043, 109, 2, 3, '2025-01-04 11:47:00', 4, 100, 'Bilheteira'),
(13386, 1002, 142, 3, 3, '2025-03-17 13:51:00', 4, 100, 'Online'),
(13387, 1079, 106, 3, 2, '2025-03-13 21:15:00', 4, 100, 'Bilheteira'),
(13388, 1083, 109, 1, 3, '2025-02-05 20:37:00', 4, 100, 'Loja Física'),
(13389, 1109, 104, 3, 2, '2025-02-19 19:50:00', 4, 100, 'Online'),
(13390, 1137, 108, 3, 2, '2025-04-10 14:32:00', 4, 100, 'Online'),
(13391, 1150, 106, 1, 2, '2025-02-28 14:10:00', 4, 100, 'Bilheteira'),
(13392, 1162, 107, 5, 3, '2025-03-01 21:36:00', 4, 100, 'Bilheteira'),
(13393, 1165, 108, 3, 2, '2025-03-16 17:50:00', 4, 100, 'Online'),
(13394, 1167, 107, 1, 3, '2025-02-26 17:33:00', 4, 100, 'Online'),
(13395, 1264, 110, 5, 3, '2025-04-28 09:35:00', 4, 100, 'Bilheteira'),
(13396, 1295, 142, 1, 3, '2025-01-14 11:19:00', 4, 100, 'Bilheteira'),
(13397, 1326, 110, 3, 3, '2025-03-04 11:36:00', 4, 100, 'Bilheteira'),
(13398, 1365, 106, 2, 2, '2025-02-10 15:07:00', 4, 100, 'Bilheteira'),
(13399, 1370, 109, 5, 3, '2025-02-17 19:40:00', 4, 100, 'Online'),
(13400, 1435, 106, 6, 2, '2025-02-21 15:30:00', 4, 100, 'Online'),
(13401, 1458, 106, 2, 2, '2025-04-22 11:04:00', 4, 100, 'Bilheteira'),
(13402, 1719, 142, 5, 3, '2025-01-14 11:34:00', 4, 100, 'Online'),
(13403, 1737, 104, 1, 2, '2025-03-30 11:13:00', 4, 100, 'Loja Física'),
(13404, 1741, 107, 6, 3, '2025-03-05 11:10:00', 4, 100, 'Online'),
(13405, 1745, 142, 3, 3, '2025-04-25 12:04:00', 4, 100, 'Loja Física'),
(13406, 1814, 108, 5, 2, '2025-01-26 13:42:00', 4, 100, 'Bilheteira'),
(13407, 1833, 110, 2, 3, '2025-01-31 10:09:00', 4, 100, 'Online'),
(13408, 1880, 104, 2, 2, '2025-01-11 21:30:00', 4, 100, 'Online'),
(13409, 1903, 108, 5, 2, '2025-04-18 21:07:00', 4, 100, 'Loja Física'),
(13410, 1911, 104, 1, 2, '2025-04-24 19:44:00', 4, 100, 'Bilheteira'),
(13411, 1955, 107, 4, 3, '2025-01-15 22:17:00', 4, 100, 'Loja Física'),
(13412, 1988, 109, 4, 3, '2025-04-21 12:25:00', 4, 100, 'Bilheteira'),
(13413, 1058, 114, 5, 3, '2025-03-20 22:46:00', 4, 116, 'Bilheteira'),
(13414, 1092, 113, 5, 3, '2025-01-10 19:14:00', 4, 116, 'Loja Física'),
(13415, 1106, 112, 1, 3, '2025-02-13 21:32:00', 4, 116, 'Online'),
(13416, 1138, 112, 3, 3, '2025-03-24 09:03:00', 4, 116, 'Bilheteira'),
(13417, 1140, 113, 5, 3, '2025-03-18 17:18:00', 4, 116, 'Loja Física'),
(13418, 1247, 114, 2, 3, '2025-03-31 17:58:00', 4, 116, 'Loja Física'),
(13419, 1294, 114, 1, 3, '2025-02-08 16:50:00', 4, 116, 'Bilheteira'),
(13420, 1304, 114, 5, 3, '2025-03-01 21:43:00', 4, 116, 'Loja Física'),
(13421, 1412, 111, 3, 3, '2025-04-10 22:20:00', 4, 116, 'Loja Física'),
(13422, 1451, 113, 1, 3, '2025-03-21 13:56:00', 4, 116, 'Online'),
(13423, 1457, 114, 6, 3, '2025-01-20 22:52:00', 4, 116, 'Loja Física'),
(13424, 1475, 112, 5, 3, '2025-01-14 18:55:00', 4, 116, 'Loja Física'),
(13425, 1501, 113, 3, 3, '2025-01-22 09:20:00', 4, 116, 'Online'),
(13426, 1586, 113, 1, 3, '2025-04-04 12:01:00', 4, 116, 'Bilheteira'),
(13427, 1625, 113, 1, 3, '2025-02-20 20:10:00', 4, 116, 'Bilheteira'),
(13428, 1693, 114, 2, 3, '2025-01-20 13:55:00', 4, 116, 'Online'),
(13429, 1733, 114, 2, 3, '2025-02-11 10:43:00', 4, 116, 'Loja Física'),
(13430, 1751, 111, 5, 3, '2025-03-16 12:57:00', 4, 116, 'Online'),
(13431, 1764, 112, 1, 3, '2025-03-29 17:59:00', 4, 116, 'Bilheteira'),
(13432, 1850, 114, 2, 3, '2025-03-03 22:47:00', 4, 116, 'Bilheteira'),
(13433, 1019, 116, 2, 1, '2025-04-26 17:28:00', 4, 140, 'Online'),
(13434, 1028, 116, 3, 1, '2025-03-31 20:50:00', 4, 140, 'Loja Física'),
(13435, 1051, 116, 3, 1, '2025-03-31 13:35:00', 4, 140, 'Online'),
(13436, 1081, 116, 3, 1, '2025-04-06 17:21:00', 4, 140, 'Loja Física'),
(13437, 1279, 115, 2, 1, '2025-01-11 14:25:00', 4, 140, 'Loja Física'),
(13438, 1306, 115, 3, 1, '2025-04-11 12:33:00', 4, 140, 'Bilheteira'),
(13439, 1384, 118, 2, 1, '2025-03-17 10:21:00', 4, 140, 'Bilheteira'),
(13440, 1430, 115, 5, 1, '2025-04-19 10:30:00', 4, 140, 'Loja Física'),
(13441, 1463, 116, 6, 1, '2025-01-15 10:48:00', 4, 140, 'Online'),
(13442, 1512, 118, 1, 1, '2025-04-27 12:33:00', 4, 140, 'Bilheteira'),
(13443, 1573, 115, 1, 1, '2025-01-25 22:04:00', 4, 140, 'Online'),
(13444, 1664, 118, 5, 1, '2025-03-22 17:53:00', 4, 140, 'Loja Física'),
(13445, 1722, 117, 3, 1, '2025-03-15 09:32:00', 4, 140, 'Bilheteira'),
(13446, 1724, 115, 5, 3, '2025-01-08 19:41:00', 4, 140, 'Bilheteira'),
(13447, 1771, 117, 6, 1, '2025-03-11 11:34:00', 4, 140, 'Online'),
(13448, 1948, 115, 2, 1, '2025-02-04 12:42:00', 4, 140, 'Bilheteira'),
(13449, 1131, 120, 1, 1, '2025-01-31 22:23:00', 4, 160, 'Loja Física'),
(13450, 1168, 143, 1, 1, '2025-04-10 14:43:00', 4, 160, 'Online'),
(13451, 1190, 120, 3, 1, '2025-03-22 11:51:00', 4, 160, 'Online'),
(13452, 1254, 121, 2, 1, '2025-02-18 10:43:00', 4, 160, 'Loja Física'),
(13453, 1273, 143, 2, 1, '2025-02-28 11:46:00', 4, 160, 'Online'),
(13454, 1399, 121, 5, 1, '2025-04-25 19:16:00', 4, 160, 'Loja Física'),
(13455, 1558, 143, 3, 1, '2025-04-24 10:24:00', 4, 160, 'Bilheteira'),
(13456, 1661, 143, 2, 1, '2025-04-13 09:41:00', 4, 160, 'Bilheteira'),
(13457, 1680, 143, 3, 1, '2025-01-04 10:30:00', 4, 160, 'Bilheteira'),
(13458, 1792, 143, 5, 1, '2025-02-13 11:06:00', 4, 160, 'Online'),
(13459, 1846, 119, 3, 1, '2025-04-05 15:59:00', 4, 160, 'Loja Física'),
(13460, 1877, 120, 4, 1, '2025-04-24 15:30:00', 4, 160, 'Loja Física'),
(13461, 1974, 120, 1, 1, '2025-03-18 20:21:00', 4, 160, 'Loja Física'),
(13462, 1056, 122, 6, 3, '2025-02-01 11:41:00', 4, 196, 'Online'),
(13463, 1089, 122, 5, 3, '2025-02-08 22:37:00', 4, 196, 'Bilheteira'),
(13464, 1099, 125, 3, 3, '2025-02-06 19:25:00', 4, 196, 'Online'),
(13465, 1237, 122, 1, 3, '2025-03-25 12:48:00', 4, 196, 'Bilheteira'),
(13466, 1239, 124, 6, 3, '2025-01-24 20:55:00', 4, 196, 'Online'),
(13467, 1259, 124, 5, 3, '2025-01-30 17:13:00', 4, 196, 'Online'),
(13468, 1491, 125, 6, 3, '2025-02-27 19:25:00', 4, 196, 'Bilheteira'),
(13469, 1510, 125, 1, 3, '2025-04-28 16:56:00', 4, 196, 'Online'),
(13470, 1547, 124, 3, 3, '2025-05-01 17:02:00', 4, 196, 'Bilheteira'),
(13471, 1610, 124, 2, 3, '2025-04-07 18:36:00', 4, 196, 'Online'),
(13472, 1683, 123, 3, 3, '2025-01-09 14:13:00', 4, 196, 'Loja Física'),
(13473, 1709, 122, 1, 3, '2025-02-03 11:33:00', 4, 196, 'Online'),
(13474, 1875, 123, 6, 3, '2025-02-06 19:48:00', 4, 196, 'Online'),
(13475, 1943, 125, 2, 3, '2025-01-11 22:40:00', 4, 196, 'Online'),
(13476, 1950, 122, 6, 3, '2025-03-10 10:50:00', 4, 196, 'Loja Física'),
(13477, 1077, 126, 1, 4, '2025-04-19 14:11:00', 4, 200, 'Online'),
(13478, 1087, 127, 6, 4, '2025-03-04 10:36:00', 4, 200, 'Loja Física'),
(13479, 1098, 128, 6, 4, '2025-02-14 15:21:00', 4, 200, 'Desconhecido'),
(13480, 1185, 127, 5, 4, '2025-03-18 17:01:00', 4, 200, 'Loja Física'),
(13481, 1188, 128, 6, 4, '2025-02-17 13:47:00', 4, 200, 'Bilheteira'),
(13482, 1270, 128, 1, 4, '2025-04-08 22:20:00', 4, 200, 'Bilheteira'),
(13483, 1455, 128, 1, 4, '2025-02-26 09:04:00', 4, 200, 'Loja Física'),
(13484, 1515, 126, 2, 4, '2025-03-28 16:30:00', 4, 200, 'Loja Física');
INSERT INTO `vendas` (`id`, `id_venda`, `id_produto`, `id_cidade`, `id_categoria`, `DataHora`, `Quantidade`, `Receita`, `canal_venda`) VALUES
(13485, 1612, 126, 2, 4, '2025-03-06 15:49:00', 4, 200, 'Online'),
(13486, 1622, 127, 6, 4, '2025-03-26 13:42:00', 4, 200, 'Bilheteira'),
(13487, 1638, 127, 5, 4, '2025-02-28 22:56:00', 4, 200, 'Online'),
(13488, 1678, 129, 3, 4, '2025-01-13 16:19:00', 4, 200, 'Loja Física'),
(13489, 1753, 128, 3, 4, '2025-03-05 12:05:00', 4, 200, 'Online'),
(13490, 1774, 126, 6, 4, '2025-04-26 09:08:00', 4, 200, 'Loja Física'),
(13491, 1823, 126, 3, 4, '2025-03-17 09:20:00', 4, 200, 'Loja Física'),
(13492, 1837, 126, 6, 4, '2025-05-01 22:46:00', 4, 200, 'Online'),
(13493, 1840, 126, 5, 4, '2025-03-10 14:44:00', 4, 200, 'Bilheteira'),
(13494, 1844, 128, 1, 4, '2025-04-29 13:19:00', 4, 200, 'Online'),
(13495, 1867, 128, 3, 4, '2025-01-06 16:22:00', 4, 200, 'Loja Física'),
(13496, 1886, 127, 3, 4, '2025-01-15 09:10:00', 4, 200, 'Bilheteira'),
(13497, 1893, 126, 5, 4, '2025-02-21 16:32:00', 4, 200, 'Loja Física'),
(13498, 1917, 126, 5, 4, '2025-02-13 12:51:00', 4, 200, 'Loja Física'),
(13499, 1967, 129, 5, 4, '2025-02-19 16:50:00', 4, 200, 'Loja Física'),
(13500, 1985, 129, 5, 4, '2025-04-12 19:39:00', 4, 200, 'Online'),
(13501, 1070, 132, 5, 4, '2025-03-31 13:49:00', 4, 240, 'Online'),
(13502, 1027, 131, 3, 4, '2025-04-26 09:10:00', 4, 240, 'Online'),
(13503, 1119, 130, 5, 4, '2025-04-20 16:06:00', 4, 240, 'Bilheteira'),
(13504, 1199, 132, 2, 4, '2025-02-17 14:28:00', 4, 240, 'Loja Física'),
(13505, 1309, 131, 3, 4, '2025-03-22 11:11:00', 4, 240, 'Loja Física'),
(13506, 1310, 132, 2, 4, '2025-03-17 15:24:00', 4, 240, 'Loja Física'),
(13507, 1336, 132, 1, 4, '2025-01-12 20:51:00', 4, 240, 'Online'),
(13508, 1520, 132, 5, 4, '2025-02-19 11:06:00', 4, 240, 'Online'),
(13509, 1772, 131, 5, 4, '2025-04-29 14:09:00', 4, 240, 'Loja Física'),
(13510, 1025, 135, 5, 4, '2025-02-01 22:59:00', 4, 280, 'Bilheteira'),
(13511, 1052, 135, 2, 4, '2025-03-12 22:00:00', 4, 280, 'Bilheteira'),
(13512, 1060, 135, 1, 4, '2025-01-10 20:18:00', 4, 280, 'Bilheteira'),
(13513, 1177, 134, 5, 4, '2025-03-06 17:26:00', 4, 280, 'Online'),
(13514, 1292, 136, 2, 4, '2025-02-19 21:05:00', 4, 280, 'Loja Física'),
(13515, 1400, 135, 3, 4, '2025-02-17 11:28:00', 4, 280, 'Bilheteira'),
(13516, 1422, 134, 5, 4, '2025-02-02 12:29:00', 4, 280, 'Loja Física'),
(13517, 1551, 144, 5, 4, '2025-02-05 16:11:00', 4, 280, 'Online'),
(13518, 1568, 144, 1, 4, '2025-03-11 12:51:00', 4, 280, 'Bilheteira'),
(13519, 1640, 144, 4, 4, '2025-01-22 15:18:00', 4, 280, 'Online'),
(13520, 1697, 135, 6, 4, '2025-04-29 17:36:00', 4, 280, 'Online'),
(13521, 1766, 144, 3, 4, '2025-03-17 19:44:00', 4, 280, 'Loja Física'),
(13522, 1865, 135, 3, 4, '2025-04-08 11:35:00', 4, 280, 'Loja Física'),
(13523, 1991, 134, 3, 4, '2025-02-10 13:24:00', 4, 280, 'Online'),
(13524, 1053, 137, 2, 4, '2025-02-26 19:13:00', 4, 320, 'Bilheteira'),
(13525, 1059, 138, 4, 4, '2025-02-03 21:15:00', 4, 320, 'Bilheteira'),
(13526, 1063, 139, 5, 4, '2025-01-01 14:19:00', 4, 320, 'Bilheteira'),
(13527, 1142, 137, 1, 4, '2025-02-23 20:06:00', 4, 320, 'Bilheteira'),
(13528, 1318, 140, 2, 4, '2025-03-04 11:05:00', 4, 320, 'Online'),
(13529, 1613, 138, 5, 4, '2025-03-25 18:12:00', 4, 320, 'Loja Física'),
(13530, 1637, 138, 1, 4, '2025-04-10 09:38:00', 4, 320, 'Bilheteira'),
(13531, 1662, 137, 5, 4, '2025-04-29 20:03:00', 4, 320, 'Bilheteira'),
(13532, 1692, 140, 2, 4, '2025-03-11 12:42:00', 4, 320, 'Bilheteira'),
(13533, 1922, 140, 5, 4, '2025-04-04 15:52:00', 4, 320, 'Online'),
(13534, 1013, 83, 6, 1, '2025-04-07 13:49:00', 5, 60, 'Bilheteira'),
(13535, 1189, 81, 1, 1, '2025-04-05 21:21:00', 5, 60, 'Online'),
(13536, 1203, 84, 2, 1, '2025-03-11 13:57:00', 5, 60, 'Online'),
(13537, 1459, 84, 2, 1, '2025-01-29 17:41:00', 5, 60, 'Bilheteira'),
(13538, 1699, 82, 6, 1, '2025-04-24 18:05:00', 5, 60, 'Bilheteira'),
(13539, 1734, 81, 4, 1, '2025-01-23 14:04:00', 5, 60, 'Bilheteira'),
(13540, 1786, 82, 3, 1, '2025-04-06 14:37:00', 5, 60, 'Loja Física'),
(13541, 1791, 84, 2, 1, '2025-03-16 14:52:00', 5, 60, 'Online'),
(13542, 1842, 84, 2, 1, '2025-01-05 22:47:00', 5, 60, 'Online'),
(13543, 1020, 88, 6, 2, '2025-03-12 12:37:00', 5, 75, 'Online'),
(13544, 1031, 86, 6, 2, '2025-01-09 19:55:00', 5, 75, 'Bilheteira'),
(13545, 1049, 85, 2, 2, '2025-04-29 21:34:00', 5, 75, 'Loja Física'),
(13546, 1355, 88, 6, 2, '2025-03-28 09:11:00', 5, 75, 'Loja Física'),
(13547, 1545, 85, 1, 2, '2025-01-06 22:30:00', 5, 75, 'Loja Física'),
(13548, 1801, 87, 5, 2, '2025-01-28 20:12:00', 5, 75, 'Online'),
(13549, 1932, 86, 5, 2, '2025-03-22 21:49:00', 5, 75, 'Bilheteira'),
(13550, 1007, 91, 2, 3, '2025-03-23 11:34:00', 5, 90, 'Online'),
(13551, 1093, 92, 6, 3, '2025-01-29 19:09:00', 5, 90, 'Desconhecido'),
(13552, 1144, 89, 6, 2, '2025-01-08 18:35:00', 5, 90, 'Bilheteira'),
(13553, 1170, 91, 3, 3, '2025-03-26 11:58:00', 5, 90, 'Bilheteira'),
(13554, 1174, 89, 5, 2, '2025-02-18 11:10:00', 5, 90, 'Loja Física'),
(13555, 1195, 94, 1, 2, '2025-02-07 14:06:00', 5, 90, 'Bilheteira'),
(13556, 1209, 89, 5, 2, '2025-02-05 11:40:00', 5, 90, 'Loja Física'),
(13557, 1238, 95, 3, 2, '2025-04-05 20:54:00', 5, 90, 'Online'),
(13558, 1268, 94, 1, 2, '2025-04-01 12:25:00', 5, 90, 'Loja Física'),
(13559, 1311, 91, 1, 3, '2025-01-14 21:55:00', 5, 90, 'Online'),
(13560, 1382, 90, 2, 3, '2025-03-03 09:21:00', 5, 90, 'Online'),
(13561, 1431, 94, 1, 2, '2025-01-16 22:43:00', 5, 90, 'Loja Física'),
(13562, 1494, 94, 1, 2, '2025-01-29 11:47:00', 5, 90, 'Loja Física'),
(13563, 1548, 92, 2, 3, '2025-02-28 14:44:00', 5, 90, 'Online'),
(13564, 1557, 89, 1, 2, '2025-03-15 19:41:00', 5, 90, 'Online'),
(13565, 1591, 94, 5, 2, '2025-03-29 16:49:00', 5, 90, 'Online'),
(13566, 1597, 95, 2, 2, '2025-02-19 12:12:00', 5, 90, 'Loja Física'),
(13567, 1598, 92, 3, 3, '2025-02-15 19:29:00', 5, 90, 'Loja Física'),
(13568, 1599, 93, 5, 2, '2025-02-21 17:21:00', 5, 90, 'Online'),
(13569, 1624, 93, 6, 2, '2025-02-28 17:59:00', 5, 90, 'Online'),
(13570, 1687, 93, 2, 2, '2025-04-26 21:40:00', 5, 90, 'Online'),
(13571, 1790, 90, 1, 3, '2025-04-07 11:34:00', 5, 90, 'Bilheteira'),
(13572, 1802, 95, 5, 2, '2025-04-19 20:30:00', 5, 90, 'Loja Física'),
(13573, 1852, 96, 3, 3, '2025-03-24 18:40:00', 5, 90, 'Online'),
(13574, 1854, 89, 3, 2, '2025-01-16 09:45:00', 5, 90, 'Bilheteira'),
(13575, 1915, 96, 3, 3, '2025-03-17 13:15:00', 5, 90, 'Loja Física'),
(13576, 1935, 92, 3, 3, '2025-03-19 14:25:00', 5, 90, 'Online'),
(13577, 1969, 95, 3, 2, '2025-01-17 19:32:00', 5, 90, 'Bilheteira'),
(13578, 1073, 103, 1, 2, '2025-02-24 19:23:00', 5, 110, 'Loja Física'),
(13579, 1094, 100, 6, 2, '2025-04-06 22:36:00', 5, 110, 'Bilheteira'),
(13580, 1096, 98, 5, 2, '2025-02-02 09:05:00', 5, 110, 'Loja Física'),
(13581, 1102, 100, 6, 2, '2025-01-17 13:28:00', 5, 110, 'Bilheteira'),
(13582, 1176, 102, 1, 1, '2025-01-31 13:51:00', 5, 110, 'Online'),
(13583, 1205, 102, 3, 1, '2025-04-24 10:04:00', 5, 110, 'Bilheteira'),
(13584, 1255, 101, 6, 1, '2025-02-20 17:08:00', 5, 110, 'Online'),
(13585, 1283, 103, 6, 2, '2025-03-14 19:02:00', 5, 110, 'Bilheteira'),
(13586, 1320, 103, 3, 2, '2025-04-16 14:34:00', 5, 110, 'Loja Física'),
(13587, 1330, 97, 6, 1, '2025-04-20 16:50:00', 5, 110, 'Loja Física'),
(13588, 1345, 98, 6, 2, '2025-04-09 15:27:00', 5, 110, 'Bilheteira'),
(13589, 1378, 98, 2, 2, '2025-01-30 11:06:00', 5, 110, 'Loja Física'),
(13590, 1379, 101, 2, 1, '2025-04-19 21:24:00', 5, 110, 'Online'),
(13591, 1408, 103, 3, 2, '2025-04-23 14:56:00', 5, 110, 'Bilheteira'),
(13592, 1456, 100, 3, 2, '2025-03-08 20:44:00', 5, 110, 'Online'),
(13593, 1480, 98, 6, 2, '2025-02-03 11:10:00', 5, 110, 'Bilheteira'),
(13594, 1506, 102, 5, 1, '2025-04-04 22:18:00', 5, 110, 'Bilheteira'),
(13595, 1507, 98, 2, 2, '2025-01-02 19:15:00', 5, 110, 'Loja Física'),
(13596, 1511, 99, 3, 2, '2025-03-11 18:11:00', 5, 110, 'Loja Física'),
(13597, 1626, 97, 3, 1, '2025-02-05 21:03:00', 5, 110, 'Bilheteira'),
(13598, 1663, 101, 2, 1, '2025-03-29 14:51:00', 5, 110, 'Online'),
(13599, 1800, 97, 5, 1, '2025-04-10 20:39:00', 5, 110, 'Loja Física'),
(13600, 1806, 102, 6, 1, '2025-02-22 13:54:00', 5, 110, 'Online'),
(13601, 1847, 100, 5, 2, '2025-01-09 14:26:00', 5, 110, 'Loja Física'),
(13602, 1925, 103, 1, 2, '2025-02-07 09:33:00', 5, 110, 'Online'),
(13603, 1944, 141, 3, 1, '2025-02-24 17:28:00', 5, 110, 'Online'),
(13604, 1467, 105, 6, 2, '2025-03-06 11:31:00', 5, 125, 'Loja Física'),
(13605, 1629, 109, 1, 3, '2025-03-11 19:51:00', 5, 125, 'Online'),
(13606, 1030, 108, 5, 2, '2025-04-28 22:33:00', 5, 125, 'Online'),
(13607, 1065, 142, 5, 3, '2025-03-10 09:58:00', 5, 125, 'Loja Física'),
(13608, 1154, 106, 2, 2, '2025-01-08 09:13:00', 5, 125, 'Online'),
(13609, 1216, 104, 5, 2, '2025-02-23 12:55:00', 5, 125, 'Bilheteira'),
(13610, 1256, 104, 3, 2, '2025-02-24 17:24:00', 5, 125, 'Online'),
(13611, 1402, 104, 3, 2, '2025-01-30 17:03:00', 5, 125, 'Desconhecido'),
(13612, 1406, 108, 3, 2, '2025-02-20 17:20:00', 5, 125, 'Loja Física'),
(13613, 1460, 105, 1, 2, '2025-02-27 10:54:00', 5, 125, 'Bilheteira'),
(13614, 1476, 142, 6, 3, '2025-04-11 21:51:00', 5, 125, 'Bilheteira'),
(13615, 1483, 106, 2, 2, '2025-03-10 15:05:00', 5, 125, 'Online'),
(13616, 1628, 142, 3, 3, '2025-01-20 15:19:00', 5, 125, 'Bilheteira'),
(13617, 1630, 142, 5, 3, '2025-04-28 11:20:00', 5, 125, 'Loja Física'),
(13618, 1749, 110, 6, 3, '2025-04-26 11:36:00', 5, 125, 'Online'),
(13619, 1862, 110, 6, 3, '2025-03-05 14:56:00', 5, 125, 'Online'),
(13620, 1869, 110, 3, 3, '2025-01-01 17:49:00', 5, 125, 'Online'),
(13621, 1899, 109, 1, 3, '2025-03-04 10:50:00', 5, 125, 'Bilheteira'),
(13622, 1015, 112, 5, 3, '2025-03-19 12:09:00', 5, 145, 'Online'),
(13623, 1037, 113, 1, 3, '2025-01-27 20:21:00', 5, 145, 'Loja Física'),
(13624, 1042, 112, 4, 3, '2025-04-24 22:26:00', 5, 145, 'Loja Física'),
(13625, 1171, 112, 5, 3, '2025-02-18 19:50:00', 5, 145, 'Online'),
(13626, 1286, 112, 6, 3, '2025-04-09 18:38:00', 5, 145, 'Desconhecido'),
(13627, 1358, 114, 5, 3, '2025-03-05 21:49:00', 5, 145, 'Loja Física'),
(13628, 1380, 113, 5, 3, '2025-01-04 20:44:00', 5, 145, 'Loja Física'),
(13629, 1675, 112, 2, 3, '2025-04-25 14:34:00', 5, 145, 'Online'),
(13630, 1783, 114, 1, 3, '2025-03-04 09:52:00', 5, 145, 'Loja Física'),
(13631, 1078, 115, 2, 1, '2025-03-31 13:35:00', 5, 175, 'Loja Física'),
(13632, 1351, 118, 1, 1, '2025-03-22 10:31:00', 5, 175, 'Loja Física'),
(13633, 1464, 115, 2, 1, '2025-03-08 14:44:00', 5, 175, 'Desconhecido'),
(13634, 1541, 116, 1, 1, '2025-03-10 09:44:00', 5, 175, 'Online'),
(13635, 1556, 115, 3, 1, '2025-03-13 21:16:00', 5, 175, 'Online'),
(13636, 1596, 118, 2, 1, '2025-01-06 20:04:00', 5, 175, 'Online'),
(13637, 1609, 118, 2, 1, '2025-03-14 11:20:00', 5, 175, 'Loja Física'),
(13638, 1616, 117, 3, 1, '2025-04-16 21:28:00', 5, 175, 'Online'),
(13639, 1700, 118, 3, 1, '2025-04-10 09:30:00', 5, 175, 'Loja Física'),
(13640, 1828, 118, 1, 1, '2025-04-13 13:27:00', 5, 175, 'Loja Física'),
(13641, 1912, 118, 2, 1, '2025-03-20 11:44:00', 5, 175, 'Bilheteira'),
(13642, 1048, 143, 1, 1, '2025-03-07 10:24:00', 5, 200, 'Online'),
(13643, 1147, 120, 5, 1, '2025-04-09 22:39:00', 5, 200, 'Loja Física'),
(13644, 1221, 119, 5, 1, '2025-02-27 21:35:00', 5, 200, 'Loja Física'),
(13645, 1225, 143, 4, 1, '2025-02-08 16:52:00', 5, 200, 'Bilheteira'),
(13646, 1269, 121, 5, 1, '2025-03-25 14:19:00', 5, 200, 'Bilheteira'),
(13647, 1469, 121, 3, 1, '2025-04-28 20:48:00', 5, 200, 'Bilheteira'),
(13648, 1538, 120, 1, 1, '2025-01-14 17:04:00', 5, 200, 'Bilheteira'),
(13649, 1656, 120, 5, 1, '2025-04-04 19:31:00', 5, 200, 'Online'),
(13650, 1702, 119, 5, 1, '2025-01-22 18:03:00', 5, 200, 'Bilheteira'),
(13651, 1775, 119, 1, 1, '2025-04-18 12:28:00', 5, 200, 'Online'),
(13652, 1834, 121, 2, 1, '2025-02-25 15:41:00', 5, 200, 'Online'),
(13653, 1929, 121, 3, 1, '2025-01-17 21:08:00', 5, 200, 'Loja Física'),
(13654, 1116, 124, 2, 3, '2025-03-29 12:31:00', 5, 245, 'Online'),
(13655, 1166, 125, 4, 3, '2025-01-20 09:28:00', 5, 245, 'Bilheteira'),
(13656, 1248, 124, 6, 3, '2025-04-01 14:04:00', 5, 245, 'Online'),
(13657, 1381, 123, 6, 3, '2025-02-09 11:31:00', 5, 245, 'Online'),
(13658, 1395, 123, 1, 3, '2025-04-03 20:34:00', 5, 245, 'Loja Física'),
(13659, 1420, 125, 3, 3, '2025-01-03 22:49:00', 5, 245, 'Online'),
(13660, 1498, 124, 6, 3, '2025-01-10 13:42:00', 5, 245, 'Bilheteira'),
(13661, 1550, 125, 2, 3, '2025-02-13 14:11:00', 5, 245, 'Bilheteira'),
(13662, 1695, 122, 5, 3, '2025-04-30 15:39:00', 5, 245, 'Bilheteira'),
(13663, 1859, 122, 6, 3, '2025-02-02 10:06:00', 5, 245, 'Online'),
(13664, 1998, 122, 1, 3, '2025-01-04 14:08:00', 5, 245, 'Online'),
(13665, 1072, 129, 1, 4, '2025-03-30 22:40:00', 5, 250, 'Online'),
(13666, 1141, 127, 2, 4, '2025-04-03 22:13:00', 5, 250, 'Bilheteira'),
(13667, 1274, 129, 4, 4, '2025-01-05 22:54:00', 5, 250, 'Loja Física'),
(13668, 1276, 126, 3, 4, '2025-03-23 19:59:00', 5, 250, 'Bilheteira'),
(13669, 1362, 127, 5, 4, '2025-01-18 19:52:00', 5, 250, 'Online'),
(13670, 1374, 129, 3, 4, '2025-03-21 18:15:00', 5, 250, 'Bilheteira'),
(13671, 1423, 127, 5, 4, '2025-03-26 22:53:00', 5, 250, 'Loja Física'),
(13672, 1492, 127, 6, 4, '2025-01-09 21:47:00', 5, 250, 'Online'),
(13673, 1513, 128, 6, 4, '2025-04-23 11:28:00', 5, 250, 'Online'),
(13674, 1523, 126, 1, 4, '2025-02-24 12:51:00', 5, 250, 'Desconhecido'),
(13675, 1590, 129, 1, 4, '2025-04-20 14:49:00', 5, 250, 'Online'),
(13676, 1648, 128, 3, 4, '2025-04-23 16:15:00', 5, 250, 'Loja Física'),
(13677, 1686, 127, 6, 4, '2025-04-09 22:24:00', 5, 250, 'Bilheteira'),
(13678, 1698, 126, 5, 4, '2025-03-03 20:05:00', 5, 250, 'Loja Física'),
(13679, 1723, 128, 6, 4, '2025-01-29 09:24:00', 5, 250, 'Bilheteira'),
(13680, 1894, 129, 6, 4, '2025-01-03 15:36:00', 5, 250, 'Loja Física'),
(13681, 1519, 133, 1, 4, '2025-03-26 17:16:00', 5, 300, 'Loja Física'),
(13682, 1022, 133, 2, 4, '2025-03-15 16:15:00', 5, 300, 'Bilheteira'),
(13683, 1057, 133, 3, 4, '2025-03-01 09:35:00', 5, 300, 'Online'),
(13684, 1315, 131, 5, 4, '2025-02-19 15:11:00', 5, 300, 'Loja Física'),
(13685, 1387, 132, 5, 4, '2025-02-10 21:39:00', 5, 300, 'Loja Física'),
(13686, 1419, 132, 2, 4, '2025-04-10 12:54:00', 5, 300, 'Loja Física'),
(13687, 1454, 131, 2, 4, '2025-02-18 21:22:00', 5, 300, 'Online'),
(13688, 1468, 131, 3, 4, '2025-01-23 20:52:00', 5, 300, 'Online'),
(13689, 1503, 132, 2, 4, '2025-01-11 22:17:00', 5, 300, 'Loja Física'),
(13690, 1567, 133, 5, 4, '2025-03-18 16:40:00', 5, 300, 'Loja Física'),
(13691, 1608, 132, 6, 4, '2025-04-29 09:40:00', 5, 300, 'Bilheteira'),
(13692, 1654, 133, 4, 4, '2025-01-08 10:36:00', 5, 300, 'Loja Física'),
(13693, 1712, 131, 2, 4, '2025-04-09 12:33:00', 5, 300, 'Loja Física'),
(13694, 1750, 131, 3, 4, '2025-03-02 22:29:00', 5, 300, 'Online'),
(13695, 1818, 131, 3, 4, '2025-01-08 15:16:00', 5, 300, 'Loja Física'),
(13696, 1008, 134, 6, 4, '2025-01-29 19:20:00', 5, 350, 'Online'),
(13697, 1018, 135, 2, 4, '2025-04-22 18:27:00', 5, 350, 'Loja Física'),
(13698, 1075, 135, 3, 4, '2025-04-14 17:49:00', 5, 350, 'Bilheteira'),
(13699, 1112, 136, 5, 4, '2025-02-18 14:40:00', 5, 350, 'Bilheteira'),
(13700, 1157, 136, 3, 4, '2025-02-24 18:25:00', 5, 350, 'Loja Física'),
(13701, 1219, 134, 1, 4, '2025-01-02 22:06:00', 5, 350, 'Online'),
(13702, 1328, 134, 3, 4, '2025-01-01 22:49:00', 5, 350, 'Online'),
(13703, 1391, 134, 4, 4, '2025-02-18 10:53:00', 5, 350, 'Loja Física'),
(13704, 1478, 135, 2, 4, '2025-03-11 20:38:00', 5, 350, 'Loja Física'),
(13705, 1529, 144, 2, 4, '2025-02-14 21:45:00', 5, 350, 'Loja Física'),
(13706, 1600, 144, 3, 4, '2025-02-11 22:23:00', 5, 350, 'Loja Física'),
(13707, 1710, 134, 1, 4, '2025-03-29 09:06:00', 5, 350, 'Loja Física'),
(13708, 1735, 135, 2, 4, '2025-01-22 16:15:00', 5, 350, 'Online'),
(13709, 1810, 134, 1, 4, '2025-03-17 13:48:00', 5, 350, 'Bilheteira'),
(13710, 1887, 134, 3, 4, '2025-04-15 18:23:00', 5, 350, 'Loja Física'),
(13711, 1921, 136, 1, 4, '2025-02-21 18:35:00', 5, 350, 'Bilheteira'),
(13712, 1959, 134, 6, 4, '2025-04-08 09:56:00', 5, 350, 'Online'),
(13713, 1971, 144, 3, 4, '2025-04-24 17:49:00', 5, 350, 'Online'),
(13714, 1983, 144, 5, 4, '2025-02-24 19:15:00', 5, 350, 'Loja Física'),
(13715, 1152, 140, 6, 4, '2025-02-26 15:17:00', 5, 400, 'Loja Física'),
(13716, 1212, 139, 3, 4, '2025-02-07 19:19:00', 5, 400, 'Online'),
(13717, 1301, 139, 3, 4, '2025-03-03 18:25:00', 5, 400, 'Loja Física'),
(13718, 1639, 139, 3, 4, '2025-04-08 19:03:00', 5, 400, 'Bilheteira'),
(13719, 1688, 137, 1, 4, '2025-03-15 16:12:00', 5, 400, 'Loja Física'),
(13720, 1811, 140, 6, 4, '2025-02-05 11:49:00', 5, 400, 'Online'),
(13721, 1986, 137, 5, 4, '2025-03-01 11:20:00', 5, 400, 'Bilheteira');

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
