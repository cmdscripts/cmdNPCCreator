CREATE TABLE `npcbuilder` (
  `model` varchar(250) NOT NULL,
  `position` longtext NOT NULL,
  `animation` varchar(250) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `npcbuilder`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `npcbuilder`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
COMMIT;