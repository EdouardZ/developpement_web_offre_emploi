-- =============================================
-- JOBBOARD — Script SQL complet
-- Projet B1 — ECE Bordeaux 2025-2026
-- =============================================

CREATE DATABASE IF NOT EXISTS jobboard
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE jobboard;

-- =============================================
-- TABLE : utilisateurs
-- =============================================
CREATE TABLE IF NOT EXISTS utilisateurs (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    nom          VARCHAR(100)  NOT NULL,
    email        VARCHAR(150)  NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255)  NOT NULL,           -- stocké hashé (bcrypt)
    cv_texte     TEXT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =============================================
-- TABLE : offres
-- =============================================
CREATE TABLE IF NOT EXISTS offres (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    titre        VARCHAR(200)  NOT NULL,
    description  TEXT          NOT NULL,
    salaire      DECIMAL(10,2) DEFAULT NULL,
    lieu         VARCHAR(150)  DEFAULT NULL,
    type_contrat ENUM('CDI','CDD','Freelance','Stage','Intérim') NOT NULL,
    id_createur  INT           NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_offre_createur
        FOREIGN KEY (id_createur)
        REFERENCES utilisateurs(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================
-- TABLE : candidatures (table de liaison)
-- =============================================
CREATE TABLE IF NOT EXISTS candidatures (
    id_utilisateur INT NOT NULL,
    id_offre       INT NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_utilisateur, id_offre),        -- empêche les doublons
    CONSTRAINT fk_cand_utilisateur
        FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateurs(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_cand_offre
        FOREIGN KEY (id_offre)
        REFERENCES offres(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================
-- DONNÉES DE TEST
-- Mots de passe : tous "password123"
-- Hash généré par : password_hash('password123', PASSWORD_DEFAULT)
-- =============================================

INSERT INTO utilisateurs (nom, email, mot_de_passe, cv_texte) VALUES
(
    'Alice Martin',
    'alice@exemple.com',
    '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'Développeuse web 3 ans d''expérience. PHP, Laravel, Vue.js, MySQL. Passionnée par les architectures propres et le TDD.'
),
(
    'Bob Dupont',
    'bob@exemple.com',
    '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'Technicien réseaux et systèmes. Certifié Cisco CCNA. Administration Linux, virtualisation VMware, monitoring Zabbix.'
),
(
    'Clara Nguyen',
    'clara@exemple.com',
    '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'Étudiante en BUT Informatique 2e année. Compétences : Python, HTML/CSS, bases de données relationnelles, SQL.'
);

INSERT INTO offres (titre, description, salaire, lieu, type_contrat, id_createur) VALUES
(
    'Développeur PHP / Laravel — Alternance',
    'Rejoignez notre agence web dynamique basée à Bordeaux pour développer des applications métier sur mesure.\n\nMissions :\n- Développement de fonctionnalités en PHP/Laravel\n- Intégration d''APIs RESTful\n- Rédaction de tests unitaires\n- Participation aux revues de code\n\nProfil recherché :\n- Étudiant en BUT Informatique, Licence ou Mastère\n- Connaissance de PHP et SQL\n- Autonomie et curiosité\n\nRythme : 3 jours entreprise / 2 jours école.',
    1800.00,
    'Bordeaux',
    'CDI',
    1
),
(
    'Administrateur systèmes Linux — CDI',
    'Nous recherchons un admin sys expérimenté pour rejoindre notre DSI.\n\nMissions :\n- Administration de serveurs Debian/Ubuntu\n- Gestion de la sauvegarde et de la continuité de service\n- Supervision réseau (Zabbix, Nagios)\n- Automatisation avec Ansible et Bash\n\nProfil :\n- 2 ans d''expérience minimum\n- Maîtrise de Linux en environnement de production\n- Capacité à travailler en équipe',
    2900.00,
    'Toulouse',
    'CDI',
    2
),
(
    'Stage Développeur Web — 6 mois',
    'Startup SaaS cherche stagiaire développeur web pour renforcer son équipe.\n\nTech stack : React, Node.js, PostgreSQL, Docker.\n\nMissions :\n- Contribution au développement du front-end React\n- Mise en place de composants réutilisables\n- Documentation technique\n\nConvention de stage obligatoire. Gratification légale.',
    600.00,
    'Paris — Télétravail partiel',
    'Stage',
    1
),
(
    'Technicien support N2 — CDD 6 mois',
    'Mission de support technique niveau 2 pour un grand compte dans le secteur bancaire.\n\nResponsabilités :\n- Diagnostic et résolution d''incidents réseau et postes de travail\n- Escalade vers le N3 si nécessaire\n- Rédaction de tickets ITSM (ServiceNow)\n\nProfil : BTS SIO ou équivalent, expérience support appréciée.',
    2100.00,
    'Lyon',
    'CDD',
    2
),
(
    'Développeur Freelance — Mission React',
    'Mission freelance de 3 mois pour refonte d''interface client.\n\nDétail :\n- Refonte complète de l''UI en React + TypeScript\n- Intégration de Figma vers code\n- Livraison par sprints de 2 semaines\n\nTJM : selon profil. Début : dès que possible.',
    NULL,
    'Bordeaux ou full remote',
    'Freelance',
    1
);

-- Candidatures de test
INSERT INTO candidatures (id_utilisateur, id_offre) VALUES
(3, 1),
(2, 3),
(3, 2);

