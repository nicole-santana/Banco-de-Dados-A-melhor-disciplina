-- EX 1:

DELIMITER //

CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT Nome, Sobrenome
    FROM Autor;
END;
//

DELIMITER ;
CALL sp_ListarAutores();

-- Eu tive que fazer uma gambiarra com o git, aí ele criou o readMe por causa disso, e também criou o primeiro commit sozinho

-- EX 2:
DELIMITER //
CREATE PROCEDURE sp_LivrosPorCategoria(IN categoria_nome VARCHAR(200))
BEGIN
    SELECT Livro.Titulo
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID WHERE Categoria.Nome = categoria_nome
END;
//

DELIMITER ;


CALL sp_LivrosPorCategoria('Romance');
CALL sp_LivrosPorCategoria('Ciência');
CALL sp_LivrosPorCategoria('Ficção Científica');
CALL sp_LivrosPorCategoria('História');
CALL sp_LivrosPorCategoria('Autoajuda');


-- EX 3:

DELIMITER //

CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoria_nome VARCHAR(200), OUT total_livros INT)
BEGIN
    SELECT COUNT(*) INTO total_livros
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;
END;
//

DELIMITER ;

CALL sp_ContarLivrosPorCategoria('Romance', @total_livros);
CALL sp_ContarLivrosPorCategoria('Ciência', @total_livros);
CALL sp_ContarLivrosPorCategoria('Ficção Científica', @total_livros);
CALL sp_ContarLivrosPorCategoria('História', @total_livros);
CALL sp_ContarLivrosPorCategoria('Autoajuda', @total_livros);



-- Assim como no ex2, eu fiz com todas as categorias
SELECT @total_livros;



-- EX 4:

DELIMITER //

CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoria_nome VARCHAR(200), OUT possui_livros VARCHAR(3))
BEGIN
 
    DECLARE contador INT;
    SET contador = 0;

    SELECT COUNT(*) INTO contador
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;

    IF contador > 0 THEN
        SET possui_livros = 'Sim';
    ELSE
        SET possui_livros = 'Não';
    END IF;
END;
//

DELIMITER ;

CALL sp_VerificarLivrosCategoria('Romance', @possui_livros);
CALL sp_VerificarLivrosCategoria('Ciência', @possui_livros);
CALL sp_VerificarLivrosCategoria('Ficção Científica',@possui_livros);
CALL sp_VerificarLivrosCategoria('História', @possui_livros);
CALL sp_VerificarLivrosCategoria('Autoajuda', @possui_livros);

SELECT @possui_livros;


-- EX 5:
DELIMITER //

CREATE PROCEDURE sp_LivrosAteAno(IN ano_limite INT)
BEGIN
    -- Listar todos os livros publicados até o ano especificado
    SELECT Titulo, Ano_Publicacao
    FROM Livro
    WHERE Ano_Publicacao <= ano_limite;
END;
//

DELIMITER ;

CALL sp_LivrosAteAno(1999);

--no caso eu coloquei o 1999 só de exemplo

-- --------------------------------------------------------------------------------------------
-- EX 6:

DELIMITER //

CREATE PROCEDURE sp_TitulosPorCategoria(IN categoria_nome VARCHAR(200))
BEGIN

    DECLARE livro_titulo VARCHAR(255);

    DECLARE cursor_livros CURSOR FOR
        SELECT Titulo
        FROM Livro
        INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
        WHERE Categoria.Nome = categoria_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET livro_titulo = NULL;
    
    OPEN cursor_livros;
    read_loop: LOOP
        FETCH cursor_livros INTO livro_titulo;
        IF livro_titulo IS NULL THEN
            LEAVE read_loop;
        END IF;
        SELECT livro_titulo;
    END LOOP;
    CLOSE cursor_livros;
END;
//

DELIMITER ;

CALL sp_TitulosPorCategoria('Romance');
