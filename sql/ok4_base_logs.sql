-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 27-Fev-2026 às 13:40
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
-- Banco de dados: `ok4_base_logs`
--
CREATE DATABASE IF NOT EXISTS `ok4_base_logs` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ok4_base_logs`;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_concelhos`
--

DROP TABLE IF EXISTS `core_concelhos`;
CREATE TABLE IF NOT EXISTS `core_concelhos` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `cod` varchar(255) DEFAULT NULL,
  `id_distrito` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_dashboard`
--

DROP TABLE IF EXISTS `core_dashboard`;
CREATE TABLE IF NOT EXISTS `core_dashboard` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `opcao` varchar(255) DEFAULT NULL,
  `espaco` varchar(255) DEFAULT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_departamento`
--

DROP TABLE IF EXISTS `core_departamento`;
CREATE TABLE IF NOT EXISTS `core_departamento` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `cod` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `idemp` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_distritos`
--

DROP TABLE IF EXISTS `core_distritos`;
CREATE TABLE IF NOT EXISTS `core_distritos` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_documento_tipo`
--

DROP TABLE IF EXISTS `core_documento_tipo`;
CREATE TABLE IF NOT EXISTS `core_documento_tipo` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `prio` varchar(255) DEFAULT NULL,
  `act` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_empresa`
--

DROP TABLE IF EXISTS `core_empresa`;
CREATE TABLE IF NOT EXISTS `core_empresa` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_user` varchar(255) DEFAULT NULL,
  `id_idioma` varchar(255) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `actcod` varchar(255) DEFAULT NULL,
  `nif` varchar(255) DEFAULT NULL,
  `morada` varchar(255) DEFAULT NULL,
  `condicoes` varchar(255) DEFAULT NULL,
  `serial` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_funcao`
--

DROP TABLE IF EXISTS `core_funcao`;
CREATE TABLE IF NOT EXISTS `core_funcao` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `ordem` varchar(255) DEFAULT NULL,
  `id_depart` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_idioma`
--

DROP TABLE IF EXISTS `core_idioma`;
CREATE TABLE IF NOT EXISTS `core_idioma` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `acro` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_login`
--

DROP TABLE IF EXISTS `core_login`;
CREATE TABLE IF NOT EXISTS `core_login` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_tipo` varchar(255) DEFAULT NULL,
  `id_lang` varchar(255) DEFAULT NULL,
  `id_user` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `pass` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_module`
--

DROP TABLE IF EXISTS `core_module`;
CREATE TABLE IF NOT EXISTS `core_module` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `cod` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_notification`
--

DROP TABLE IF EXISTS `core_notification`;
CREATE TABLE IF NOT EXISTS `core_notification` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_user` varchar(255) DEFAULT NULL,
  `id_sent` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_pais`
--

DROP TABLE IF EXISTS `core_pais`;
CREATE TABLE IF NOT EXISTS `core_pais` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `cod` varchar(255) DEFAULT NULL,
  `cod_lang` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_permissao`
--

DROP TABLE IF EXISTS `core_permissao`;
CREATE TABLE IF NOT EXISTS `core_permissao` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_tipo` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `notas` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_rel_tipouser_permissao`
--

DROP TABLE IF EXISTS `core_rel_tipouser_permissao`;
CREATE TABLE IF NOT EXISTS `core_rel_tipouser_permissao` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_tipo` varchar(255) DEFAULT NULL,
  `id_perm` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_tipocont`
--

DROP TABLE IF EXISTS `core_tipocont`;
CREATE TABLE IF NOT EXISTS `core_tipocont` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `nferias` varchar(255) DEFAULT NULL,
  `contador` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_tipologin`
--

DROP TABLE IF EXISTS `core_tipologin`;
CREATE TABLE IF NOT EXISTS `core_tipologin` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_tipopermissao`
--

DROP TABLE IF EXISTS `core_tipopermissao`;
CREATE TABLE IF NOT EXISTS `core_tipopermissao` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_module` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `cod` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `sub` varchar(255) DEFAULT NULL,
  `page` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_tipouser`
--

DROP TABLE IF EXISTS `core_tipouser`;
CREATE TABLE IF NOT EXISTS `core_tipouser` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_user`
--

DROP TABLE IF EXISTS `core_user`;
CREATE TABLE IF NOT EXISTS `core_user` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_tipouser` varchar(255) DEFAULT NULL,
  `id_tipocont` varchar(255) DEFAULT NULL,
  `id_funcao` varchar(255) DEFAULT NULL,
  `id_departamento` varchar(255) DEFAULT NULL,
  `id_hl` varchar(255) DEFAULT NULL,
  `id_sexo` varchar(255) DEFAULT NULL,
  `cod` varchar(255) DEFAULT NULL,
  `abre` varchar(255) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `contacto` varchar(255) DEFAULT NULL,
  `cor` varchar(255) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `dtnasc` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_user_dash`
--

DROP TABLE IF EXISTS `core_user_dash`;
CREATE TABLE IF NOT EXISTS `core_user_dash` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_user` varchar(255) DEFAULT NULL,
  `id_dash` varchar(255) DEFAULT NULL,
  `ordem` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_user_hl`
--

DROP TABLE IF EXISTS `core_user_hl`;
CREATE TABLE IF NOT EXISTS `core_user_hl` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_user_sexo`
--

DROP TABLE IF EXISTS `core_user_sexo`;
CREATE TABLE IF NOT EXISTS `core_user_sexo` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `session_messages`
--

DROP TABLE IF EXISTS `session_messages`;
CREATE TABLE IF NOT EXISTS `session_messages` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `type_event` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `emoji` varchar(255) DEFAULT NULL,
  `id_user` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `session_messages_users`
--

DROP TABLE IF EXISTS `session_messages_users`;
CREATE TABLE IF NOT EXISTS `session_messages_users` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `acao_log` varchar(255) DEFAULT NULL,
  `iduser_text_log` varchar(255) DEFAULT NULL,
  `iduser_log` varchar(255) DEFAULT NULL,
  `dth_log` datetime DEFAULT NULL,
  `funcao_log` varchar(1000) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `id_session` varchar(255) DEFAULT NULL,
  `id_user` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
