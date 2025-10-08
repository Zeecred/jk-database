CREATE DATABASE core CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE ccb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE employeecredit CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE fgtsbmp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE payrollloanbmp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE privatelabel CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER 'core_user'@'%' IDENTIFIED BY 'Kxs3#Lm@Jk';
GRANT ALL PRIVILEGES ON core.* TO 'core_user'@'%';

CREATE USER 'ccb_user'@'%' IDENTIFIED BY 'mZ3#Pq@Jk';
GRANT ALL PRIVILEGES ON ccb.* TO 'ccb_user'@'%';

CREATE USER 'employeecredit_user'@'%' IDENTIFIED BY 'Qw4#Rt@Jk';
GRANT ALL PRIVILEGES ON employeecredit.* TO 'employeecredit_user'@'%';

CREATE USER 'fgtsbmp_user'@'%' IDENTIFIED BY 'Hk5#Jp@Jk';
GRANT ALL PRIVILEGES ON fgtsbmp.* TO 'fgtsbmp_user'@'%';

CREATE USER 'payrollloanbmp_user'@'%' IDENTIFIED BY 'Xc3#Lq@Jk';
GRANT ALL PRIVILEGES ON payrollloanbmp.* TO 'payrollloanbmp_user'@'%';

CREATE USER 'privatelabel_user'@'%' IDENTIFIED BY 'Rt4#Vw@Jk';
GRANT ALL PRIVILEGES ON privatelabel.* TO 'privatelabel_user'@'%';
