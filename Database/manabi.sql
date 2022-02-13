PGDMP         .                z            Manabi    14.1    14.1 G    g           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            h           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            i           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            j           1262    16394    Manabi    DATABASE     d   CREATE DATABASE "Manabi" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Italian_Italy.1252';
    DROP DATABASE "Manabi";
                postgres    false            �            1255    16395    aggiorna_punteggiotot()    FUNCTION     j  CREATE FUNCTION public.aggiorna_punteggiotot() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
username STUDENTE.USERNAME_S%TYPE;
punteggio STUDENTE.PUNTEGGIO_TOT%TYPE;
Voto CORREZIONE.VOTO_TEST%TYPE;
BEGIN

	SELECT CORREZIONE.VOTO_TEST, CORREZIONE.USERNAME_S INTO voto, username
	FROM CORREZIONE
	WHERE CORREZIONE.VOTO_TEST = NEW.VOTO_TEST;

SELECT STUDENTE.PUNTEGGIO_TOT INTO punteggio
	FROM STUDENTE
	WHERE STUDENTE.USERNAME_S = username;

	punteggio := punteggio + voto;
                UPDATE STUDENTE
	SET STUDENTE.PUNTEGGIO_TOT = punteggio
	WHERE (STUDENTE.USERNAME_S = username);
RETURN NULL;
END;

$$;
 .   DROP FUNCTION public.aggiorna_punteggiotot();
       public          postgres    false            �            1255    16396    aggiorna_voto_a()    FUNCTION     <  CREATE FUNCTION public.aggiorna_voto_a() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
DECLARE
punteggio RISPOSTA_APERTA.PUNTEGGIO_RISA%TYPE;
username RISPOSTA_APERTA.USERNAME_S%TYPE;
idra RISPOSTA_APERTA.IDR_A%TYPE;
idTestQ QUESITO_APERTO.ID_TEST%TYPE;
voto CORREZIONE.VOTO_TEST%TYPE;

BEGIN
SELECT RISPOSTA_APERTA.PUNTEGGIO_RISA, RISPOSTA_APERTE.USERNAME_S, RISPOSTA_APERTA.IDR_A INTO punteggio, username, idra
FROM RISPOSTA_APERTA
WHERE RISPOSTA_APERTA.PUNTEGIO_RISA = NEW.PUNTEGGIO_RISA;

SELECT QUESITO_APERTO.ID_TEST INTO idTestQ
FROM QUESITO_APERTO
WHERE QUESITO_APERTO.ID_A = idra;

SELECT CORREZIONE.VOTO_TEST INTO voto
FROM CORREZIONE
WHERE CORREZIONE.ID_TEST = idTestQ;

voto := voto + punteggio;

UPDATE CORREZIONE
SET CORREZIONE.VOTO_TEST = voto
WHERE CORREZIONE.USERNAME_S = username; 



RETURN NULL;
END;

$$;
 (   DROP FUNCTION public.aggiorna_voto_a();
       public          postgres    false            �            1255    16397    assegna_bool()    FUNCTION     c  CREATE FUNCTION public.assegna_bool() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
Rispostad RISPOSTA_APERTA.RISPOSTA_DATA%type;
runo QUESITO_MULTIPLO.R_UNOC%type;
idrm RISPOSTE_MULTIPLE.IDR_M%type;
piu QUESITO_MULTIPLO.PUNTEGGIO_CORRETTO%TYPE;
meno QUESITO_MULTIPLO.PUNTEGGIO_CORRETTO%TYPE;

BEGIN

SELECT RISPOSTA_APERTA.RISPOSTA_DATA INTO rispostad, idrm
FROM RISPOSTA_APERTA
WHERE RISPOSTA_APERTA.RISPOSTA_DATA = NEW.RISPOSTA_DATA;

SELECT QUESITO_MULTIPLO.R_UNOC, QUESITO_MULTIPLO.PUNTEGGIO_CORRETTO, QUESITO_MULTIPLO.PUNTEGGIO_ERRATO INTO runo, piu, meno
FROM QUESITO_MULTIPLO
WHERE QUESITO_MULTIPLO.ID_M = idrm;

    IF(rispostad = runo) THEN
		UPDATE RISPOSTE_MULTIPLE
		SET NEW.CORRETTA = TRUE
		WHERE RISPOSTE_MULTIPLE.IDR_M = idrm;
	
		UPDATE RISPOSTE_MULTIPLE
		SET NEW.PUNTEGGIO_RISM = piu
		WHERE RISPOSTE_MULTIPLE.IDR_M = idrm;
	END IF;	
	IF (rispostad <> runo) THEN
		UPDATE RISPOSTE_MULTIPLE
		SET NEW.CORRETTA = FALSE
		WHERE RISPOSTE_MULTIPLE.IDR_M = idrm;
	
		
		UPDATE RISPOSTE_MULTIPLE
		SET NEW.PUNTEGGIO_RISM = meno
		WHERE RISPOSTE_MULTIPLE.IDR_M = idrm;
		END IF;
RETURN NULL;
END;

$$;
 %   DROP FUNCTION public.assegna_bool();
       public          postgres    false            �            1255    16398    controllo_lunghezza_ins()    FUNCTION     �  CREATE FUNCTION public.controllo_lunghezza_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
username INSEGNANTE.USERNAME_I%TYPE;
password_i INSEGNANTE.PASSWORD_I%TYPE;
nome INSEGNANTE.NOME%TYPE;
cognome INSEGNANTE.COGNOME%TYPE;
BEGIN

	SELECT INSEGNANTE.USERNAME_I, INSEGNANTE.PASSWORD_I, INSEGNANTE.NOME, INSEGNANTE.COGNOME INTO username, password_i, nome, cognome
	FROM INSEGNANTE
	WHERE INSEGNANTE.USERNAME_I = NEW.USERNAME_I AND INSEGNANTE.PASSWORD_I = NEW.PASSWORD_I AND INSEGNANTE.NOME = NEW.NOME AND INSEGNANTE.COGNOME = NEW.COGNOME;
	
	IF(LENGTH(username) < 8 OR LENGTH(password_i) < 8) THEN
		RAISE EXCEPTION 'Username non valido'
		USING HINT = 'Prova a inserire un username più lungo';
	END IF;
	IF(LENGTH(nome) < 2 OR LENGTH(cognome) < 2) THEN
		RAISE EXCEPTION 'Nome o cognome non valido'
		USING HINT = 'Prova a inserire un nome e cognome vero!';
	END IF;
RETURN NULL;
END;

$$;
 0   DROP FUNCTION public.controllo_lunghezza_ins();
       public          postgres    false            �            1255    16399    controllo_lunghezza_stu()    FUNCTION     �  CREATE FUNCTION public.controllo_lunghezza_stu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
username STUDENTE.USERNAME_S%TYPE;
NOME STUDENTE.NOME%TYPE;
COGNOME STUDENTE.COGNOME%TYPE;
BEGIN

	SELECT STUDENTE.USERNAME_S, STUDENTE.NOME, STUDENTE.COGNOME INTO username
	FROM STUDENTE
	WHERE STUDENTE.USERNAME_S = NEW.USERNAME_S AND STUDENTE.NOME = NEW.NOME AND STUDENTE.COGNOME = NEW.COGNOME;
	
	IF(LENGTH(username) < 8) THEN
		RAISE EXCEPTION 'Username non valido'
		USING HINT = 'Prova a inserire un username più lungo';
	END IF;
	IF(LENGTH(nome) < 2 OR LENGTH(cognome) < 2) THEN
		RAISE EXCEPTION 'Nome o cognome non valido'
		USING HINT = 'Prova a inserire un nome e cognome vero!';
	END IF;
RETURN NULL;
END;

$$;
 0   DROP FUNCTION public.controllo_lunghezza_stu();
       public          postgres    false            �            1255    16400    controllo_risa()    FUNCTION     �  CREATE FUNCTION public.controllo_risa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
Var1 RISPOSTA_APERTA.PUNTEGGIO_RISA%type;
Var2 QUESITO_APERTO.PUNTEGGIO_MAX%type;
Var3 QUESITO_APERTO.PUNTEGGIO_MIN%type;
idquiz RISPOSTA_APERTA.IDR_A%TYPE;
BEGIN
SELECT RISPOSTA_APERTA.PUNTEGGIO_RISA, RISPOSTA_APERTA.IDR_A INTO VAR1, idquiz
FROM RISPOSTA_APERTA
WHERE PUNTEGGIO_RISA = NEW.PUNTEGGIO_RISA;

SELECT QUESITO_APERTO.PUNTEGGIO_MAX, QUESITO_APERTO.PUNTEGGIO_MIN INTO VAR2, VAR2
FROM QUIZ_APERTO
WHERE QUESITO_APERTO.ID_A = idquiz;

IF (VAR1>VAR2 AND VAR1<VAR3)
THEN
RAISE EXCEPTION 'ERROR punteggio non valido';
RETURN NULL;
END IF;
END;
$$;
 '   DROP FUNCTION public.controllo_risa();
       public          postgres    false            �            1255    16401    controllo_risposta()    FUNCTION     �  CREATE FUNCTION public.controllo_risposta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
rispostaData RISPOSTE_MULTIPLE.RISPOSTA_DATA%type;
rispostaU RISPOSTE_MULTIPLE.RISPOSTA_DATA%type;
rispostaD RISPOSTE_MULTIPLE.RISPOSTA_DATA%type;
rispostaT RISPOSTE_MULTIPLE.RISPOSTA_DATA%type;
rispostaQ RISPOSTE_MULTIPLE.RISPOSTA_DATA%type;
rispostaC RISPOSTE_MULTIPLE.RISPOSTA_DATA%type;

BEGIN
	SELECT RISPOSTE_MULTIPLE.RISPOSTA_DATA INTO rispostaData
	FROM RISPOSTE_MULTIPLE
	WHERE RISPOSTE_MULTIPLE.RISPOSTA_DATA = NEW.RISPOSTA_DATA;

	SELECT QUESITO_MULTIPLO.R_UNOC INTO rispostaU
    FROM QUESITO_MULTIPLO, RISPOSTE_MULTIPLE
    WHERE QUESITO_MULTIPLO.ID_M = RISPOSTE_MULTIPLE.IDR_M;

SELECT QUESITO_MULTIPLO.R_DUE INTO rispostaD
FROM QUESITO_MULTIPLO, RISPOSTE_MULTIPLE
WHERE QUESITO_MULTIPLO.ID_M = RISPOSTE_MULTIPLE.IDR_M;

SELECT QUESITO_MULTIPLO.R_TRE INTO rispostaT
FROM QUESITO_MULTIPLO, RISPOSTE_MULTIPLE
WHERE QUESITO_MULTIPLO.ID_M = RISPOSTE_MULTIPLE.IDR_M;

SELECT QUESITO_MULTIPLO.R_QUATTRO INTO rispostaQ
FROM QUESITO_MULTIPLO, RISPOSTE_MULTIPLE
WHERE QUESITO_MULTIPLO.ID_M = RISPOSTE_MULTIPLE.IDR_M;


SELECT QUESITO_MULTIPLO.R_CINQUE INTO rispostaC
FROM QUESITO_MULTIPLO, RISPOSTE_MULTIPLE
WHERE QUESITO_MULTIPLO.ID_M = RISPOSTE_MULTIPLE.IDR_M;

		IF(rispostaData <> rispostaU AND rispostaData<> rispostaD
		AND rispostaT IS NULL AND rispostaQ IS NULL AND rispostaC IS NULL)
		THEN RAISE EXCEPTION 'Risposta data non valida.';
		END IF;
		
		IF(rispostaData <> rispostaU AND rispostaData<> rispostaD
		AND (rispostaT IS NOT NULL AND rispostaData <> rispostaT) AND rispostaQ IS NULL AND rispostaC IS NULL)
		THEN RAISE EXCEPTION 'Risposta data non valida.';
		END IF;
		
		IF(rispostaData <> rispostaU AND rispostaData<> rispostaD
		AND (rispostaT IS NOT NULL AND rispostaData <> rispostaT)  AND 
		    (rispostaQ IS NOT NULL AND rispostaD<> rispostaQ) AND rispostaC IS NULL)
		THEN RAISE EXCEPTION 'Risposta data non valida.';
		END IF;
			
		IF (rispostaData <> rispostaU AND rispostaData<> rispostaD
		AND (rispostaT IS NOT NULL AND rispostaData <> rispostaT)  AND 
		    (rispostaQ IS NOT NULL AND rispostaD<> rispostaQ) AND
			(rispostaC IS NOT NULL AND rispostaD <> rispostaC))
		THEN RAISE EXCEPTION 'Risposta data non valida.';
		END IF;

RETURN NULL;
END;

$$;
 +   DROP FUNCTION public.controllo_risposta();
       public          postgres    false            �            1255    16402    controllo_tempo()    FUNCTION     �  CREATE FUNCTION public.controllo_tempo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
tempo TIME;
BEGIN
SELECT TEST.TEMPO_SVOLGIMENTO INTO tempo
FROM TEST
WHERE TEST.TEMPO_SVOLGIMENTO = NEW.TEMPO_SVOLGIMENTO;

    IF(tempo < '00:15:00' AND tempo IS NOT NULL) THEN
	RAISE EXCEPTION 'Tempo insufficiente per svolgere il test.'
		USING HINT = 'Prova ad assegnare maggior tempo (>= 15 min)';
		END IF;
RETURN NULL;
END;

$$;
 (   DROP FUNCTION public.controllo_tempo();
       public          postgres    false            �            1255    16403    controllo_username_i()    FUNCTION     A  CREATE FUNCTION public.controllo_username_i() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
username_s VARCHAR(25);
username_i VARCHAR(25);
BEGIN
	SELECT INSEGNANTE.USERNAME_I INTO username_i
	FROM INSEGNANTE
	WHERE INSEGNANTE.USERNAME_I = NEW.USERNAME_I;

	SELECT STUDENTE.USERNAME_S INTO username_s
	FROM STUDENTE
	WHERE STUDENTE.USERNAME_S = username_i;
	
	IF(username_s = username_i AND username_s IS NOT NULL) THEN
	RAISE EXCEPTION 'Questo username non è disponibile.'
		USING HINT = 'Prova con un inserire un username diverso.';
	END IF;
RETURN NULL;
END;

$$;
 -   DROP FUNCTION public.controllo_username_i();
       public          postgres    false            �            1255    16404    controllo_username_s()    FUNCTION     F  CREATE FUNCTION public.controllo_username_s() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
username_s VARCHAR(25);
username_i VARCHAR(25);
BEGIN

    SELECT STUDENTE.USERNAME_S INTO username_s
	FROM STUDENTE
	WHERE STUDENTE.USERNAME_S = NEW.USERNAME_S;
	
	SELECT INSEGNANTE.USERNAME_I INTO username_i
	FROM INSEGNANTE
	WHERE INSEGNANTE.USERNAME_I = username_s;


	IF(username_s = username_i AND username_i IS NOT NULL) THEN
	RAISE EXCEPTION 'Questo username non è disponibile.'
		USING HINT = 'Prova con un inserire un username diverso.';
	END IF;
RETURN NULL;
END;

$$;
 -   DROP FUNCTION public.controllo_username_s();
       public          postgres    false            �            1255    16405    somma_mul()    FUNCTION     e  CREATE FUNCTION public.somma_mul() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
DECLARE
punteggio RISPOSTE_MULTIPLE.PUNTEGGIO_RM%TYPE;
username RISPOSTE_MULTIPLE.USERNAME_S%TYPE;
idrm RISPOSTE_MULTIPLE.IDR_M%TYPE;
idTestQ QUESITO_MULTIPLO.ID_TEST%TYPE;
voto CORREZIONE.VOTO_TEST%TYPE;
idTestC CORREZIONE.ID_TEST%TYPE;

BEGIN
SELECT RISPOSTE_MULTIPLE.PUNTEGGIO_RM, RISPOSTE_MULTIPLE.USERNAME_S, RISPOSTE_MULTIPLE.IDR_M INTO punteggio, username, idrm
FROM RISPOSTE_MULTIPLE
WHERE RISPOSTE_MULTIPLE.PUNTEGIO_RM = NEW.PUNTEGGIO_RM;

SELECT QUESITO_MULTIPLO.ID_TEST INTO idTestQ
FROM QUESITO_MULTIPLO
WHERE QUESITO_MULTIPLO.ID_M = idrm;

SELECT CORREZIONE.VOTO_TEST INTO voto
FROM CORREZIONE
WHERE CORREZIONE.ID_TEST = idTestQ;

voto := voto + punteggio;

UPDATE CORREZIONE
SET CORREZIONE.VOTO_TEST = voto
WHERE CORREZIONE.USERNAME_S = username; 

RETURN NULL;
END;

$$;
 "   DROP FUNCTION public.somma_mul();
       public          postgres    false            �            1255    16406    verifica_insegnantecorrezione()    FUNCTION     B  CREATE FUNCTION public.verifica_insegnantecorrezione() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	
IF NOT EXISTS (SELECT TEST.USERNAME_I
               FROM TEST, CORREZIONE
               WHERE TEST.USERNAME_I = NEW.USERNAME_I) THEN
RAISE EXCEPTION 'non ha creato nessun test';
END IF;


RETURN NULL;
END;
$$;
 6   DROP FUNCTION public.verifica_insegnantecorrezione();
       public          postgres    false            �            1255    16407    verifica_ipassword()    FUNCTION     �  CREATE FUNCTION public.verifica_ipassword() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
pass insegnante.password_i%type;
BEGIN
	SELECT INSEGNANTE.PASSWORD_I INTO pass
	FROM INSEGNANTE
	WHERE INSEGNANTE.PASSWORD_I = NEW.PASSWORD_I;

	IF(LENGTH(pass) < 8) THEN
	RAISE EXCEPTION 'Password % non valida', pass
		USING HINT = 'Prova a inserire una password più lunga!';
	END IF;
RETURN NULL;
END;

$$;
 +   DROP FUNCTION public.verifica_ipassword();
       public          postgres    false            �            1255    16408    verifica_spassword()    FUNCTION     �  CREATE FUNCTION public.verifica_spassword() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
spassword STUDENTE.PASSWORD_S%TYPE;
BEGIN
	SELECT PASSWORD_S INTO spassword
	FROM STUDENTE
	WHERE STUDENTE.PASSWORD_S = NEW.PASSWORD_S;
	
	IF(LENGTH(spassword) < 8) THEN
	RAISE EXCEPTION 'Password non valida'
		USING HINT = 'Prova a inserire una password più lunga!';
	END IF;
RETURN NULL;
END;

$$;
 +   DROP FUNCTION public.verifica_spassword();
       public          postgres    false            �            1259    16409 
   correzione    TABLE     �   CREATE TABLE public.correzione (
    username_i character varying(25) NOT NULL,
    username_s character varying(25) NOT NULL,
    id_test integer NOT NULL,
    corretto boolean DEFAULT false,
    voto_test double precision DEFAULT 0
);
    DROP TABLE public.correzione;
       public         heap    postgres    false            �            1259    16414 
   insegnante    TABLE     �   CREATE TABLE public.insegnante (
    username_i character varying(25) NOT NULL,
    password_i character varying(25) NOT NULL,
    nome character varying(25),
    cognome character varying(25)
);
    DROP TABLE public.insegnante;
       public         heap    postgres    false            �            1259    16417    test    TABLE     H  CREATE TABLE public.test (
    id_test integer NOT NULL,
    username_i character varying(25) NOT NULL,
    nome_test character varying(25) NOT NULL,
    tempo_svolgimento time without time zone,
    materia_test character varying(25),
    descrizione character varying(100) DEFAULT 'Nessuna descrizione.'::character varying
);
    DROP TABLE public.test;
       public         heap    postgres    false            �            1259    16421    media_categoria    VIEW     X  CREATE VIEW public.media_categoria AS
 SELECT t.nome_test,
    t.materia_test AS materia,
    c.username_s AS studente,
    avg(c.voto_test) AS media
   FROM public.test t,
    public.test p,
    public.correzione c
  GROUP BY t.nome_test, t.materia_test, c.username_s, p.materia_test
 HAVING ((t.materia_test)::text = (p.materia_test)::text);
 "   DROP VIEW public.media_categoria;
       public          postgres    false    209    209    211    211            �            1259    16425    quesito_aperto    TABLE     ,  CREATE TABLE public.quesito_aperto (
    id_a integer NOT NULL,
    id_test integer NOT NULL,
    punteggio_min double precision NOT NULL,
    punteggio_max double precision NOT NULL,
    domanda character varying(150) NOT NULL,
    CONSTRAINT controllo_pa CHECK ((punteggio_min < punteggio_max))
);
 "   DROP TABLE public.quesito_aperto;
       public         heap    postgres    false            �            1259    16429    quesito_multiplo    TABLE     �  CREATE TABLE public.quesito_multiplo (
    id_m integer NOT NULL,
    id_test integer NOT NULL,
    punteggio_corretto double precision NOT NULL,
    punteggio_errato double precision NOT NULL,
    domanda character varying(200) NOT NULL,
    r_unoc character varying(150) NOT NULL,
    r_due character varying(150) NOT NULL,
    r_tre character varying(150),
    r_quattro character varying(150),
    r_cinque character varying(150),
    CONSTRAINT controllo_pm1 CHECK ((punteggio_corretto > punteggio_errato)),
    CONSTRAINT controllo_pm2 CHECK ((punteggio_corretto > (0)::double precision)),
    CONSTRAINT controllo_pm3 CHECK ((punteggio_errato <= (0)::double precision))
);
 $   DROP TABLE public.quesito_multiplo;
       public         heap    postgres    false            �            1259    16437    risposta_aperta    TABLE     N  CREATE TABLE public.risposta_aperta (
    idr_a integer NOT NULL,
    username_s character varying(25) NOT NULL,
    username_i character varying(25) NOT NULL,
    risposta_data character varying(500),
    commento character varying(500) DEFAULT 'Nessun commento.'::character varying,
    punteggio_risa double precision DEFAULT 0
);
 #   DROP TABLE public.risposta_aperta;
       public         heap    postgres    false            �            1259    16444    risposte_multiple    TABLE     �   CREATE TABLE public.risposte_multiple (
    idr_m integer NOT NULL,
    username_s character varying(25) NOT NULL,
    risposta_data character varying(150) DEFAULT 0 NOT NULL,
    corretta boolean,
    punteggio_rm double precision DEFAULT 0
);
 %   DROP TABLE public.risposte_multiple;
       public         heap    postgres    false            �            1259    16449    risposte_errate    VIEW     �  CREATE VIEW public.risposte_errate AS
 SELECT r.username_s AS studente,
    (count(r.punteggio_risa) + count(w.corretta)) AS errate,
    q.id_test AS test
   FROM public.risposta_aperta r,
    public.quesito_aperto q,
    public.quesito_multiplo m,
    public.risposte_multiple w,
    public.risposta_aperta f,
    public.risposte_multiple y
  WHERE (((r.punteggio_risa = q.punteggio_min) OR (w.corretta = false)) AND ((r.username_s)::text = (w.username_s)::text) AND ((r.username_s)::text = (f.username_s)::text) AND ((w.username_s)::text = (y.username_s)::text) AND (q.id_test = m.id_test) AND (m.id_m = w.idr_m) AND (r.idr_a = q.id_a))
  GROUP BY r.username_s, q.id_test;
 "   DROP VIEW public.risposte_errate;
       public          postgres    false    213    213    213    216    216    216    215    215    215    214    214            �            1259    16454    risposte_esatte    VIEW     �  CREATE VIEW public.risposte_esatte AS
 SELECT r.username_s AS studente,
    (count(r.punteggio_risa) + count(w.corretta)) AS esatte,
    q.id_test AS test
   FROM public.risposta_aperta r,
    public.quesito_aperto q,
    public.quesito_multiplo m,
    public.risposte_multiple w,
    public.risposta_aperta f,
    public.risposte_multiple y
  WHERE (((r.punteggio_risa > q.punteggio_min) OR (w.corretta = true)) AND ((r.username_s)::text = (w.username_s)::text) AND ((r.username_s)::text = (f.username_s)::text) AND ((w.username_s)::text = (y.username_s)::text) AND (q.id_test = m.id_test) AND (m.id_m = w.idr_m) AND (r.idr_a = q.id_a))
  GROUP BY r.username_s, q.id_test;
 "   DROP VIEW public.risposte_esatte;
       public          postgres    false    213    216    216    216    215    215    215    214    214    213    213            �            1259    16459    studente    TABLE     �   CREATE TABLE public.studente (
    username_s character varying(25) NOT NULL,
    password_s character varying(25) NOT NULL,
    nome character varying(25),
    cognome character varying(25),
    punteggio_tot double precision DEFAULT 0
);
    DROP TABLE public.studente;
       public         heap    postgres    false            �            1259    16463    visualizza_dati_studente    VIEW     �   CREATE VIEW public.visualizza_dati_studente AS
 SELECT t.nome_test,
    count(c.username_s) AS n_studenti
   FROM public.correzione c,
    public.test t
  WHERE (c.id_test = t.id_test)
  GROUP BY t.nome_test;
 +   DROP VIEW public.visualizza_dati_studente;
       public          postgres    false    211    209    209    211            �            1259    16467    visualizza_risultati    VIEW     k  CREATE VIEW public.visualizza_risultati AS
 SELECT c.username_s AS nome_stu,
    t.nome_test,
    c.username_i AS nome_ins,
    e.esatte AS ris_esatte,
    r.errate AS ris_errate,
    c.voto_test AS voto
   FROM public.correzione c,
    public.risposte_esatte e,
    public.risposte_errate r,
    public.test t,
    public.test y
  WHERE (t.id_test = y.id_test);
 '   DROP VIEW public.visualizza_risultati;
       public          postgres    false    217    211    209    211    209    209    218            ]          0    16409 
   correzione 
   TABLE DATA           Z   COPY public.correzione (username_i, username_s, id_test, corretto, voto_test) FROM stdin;
    public          postgres    false    209   �       ^          0    16414 
   insegnante 
   TABLE DATA           K   COPY public.insegnante (username_i, password_i, nome, cognome) FROM stdin;
    public          postgres    false    210   ��       `          0    16425    quesito_aperto 
   TABLE DATA           ^   COPY public.quesito_aperto (id_a, id_test, punteggio_min, punteggio_max, domanda) FROM stdin;
    public          postgres    false    213   �       a          0    16429    quesito_multiplo 
   TABLE DATA           �   COPY public.quesito_multiplo (id_m, id_test, punteggio_corretto, punteggio_errato, domanda, r_unoc, r_due, r_tre, r_quattro, r_cinque) FROM stdin;
    public          postgres    false    214   �       b          0    16437    risposta_aperta 
   TABLE DATA           q   COPY public.risposta_aperta (idr_a, username_s, username_i, risposta_data, commento, punteggio_risa) FROM stdin;
    public          postgres    false    215   ��       c          0    16444    risposte_multiple 
   TABLE DATA           e   COPY public.risposte_multiple (idr_m, username_s, risposta_data, corretta, punteggio_rm) FROM stdin;
    public          postgres    false    216   u�       d          0    16459    studente 
   TABLE DATA           X   COPY public.studente (username_s, password_s, nome, cognome, punteggio_tot) FROM stdin;
    public          postgres    false    219   ��       _          0    16417    test 
   TABLE DATA           l   COPY public.test (id_test, username_i, nome_test, tempo_svolgimento, materia_test, descrizione) FROM stdin;
    public          postgres    false    211   ��       �           2606    16472    correzione correzione_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.correzione
    ADD CONSTRAINT correzione_pkey PRIMARY KEY (username_i, username_s, id_test);
 D   ALTER TABLE ONLY public.correzione DROP CONSTRAINT correzione_pkey;
       public            postgres    false    209    209    209            �           2606    16474    insegnante insegnante_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.insegnante
    ADD CONSTRAINT insegnante_pkey PRIMARY KEY (username_i);
 D   ALTER TABLE ONLY public.insegnante DROP CONSTRAINT insegnante_pkey;
       public            postgres    false    210            �           2606    16476    quesito_aperto quiz_aperto_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.quesito_aperto
    ADD CONSTRAINT quiz_aperto_pkey PRIMARY KEY (id_a);
 I   ALTER TABLE ONLY public.quesito_aperto DROP CONSTRAINT quiz_aperto_pkey;
       public            postgres    false    213            �           2606    16478 #   quesito_multiplo quiz_multiplo_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.quesito_multiplo
    ADD CONSTRAINT quiz_multiplo_pkey PRIMARY KEY (id_m);
 M   ALTER TABLE ONLY public.quesito_multiplo DROP CONSTRAINT quiz_multiplo_pkey;
       public            postgres    false    214            �           2606    16480 $   risposta_aperta risposta_aperte_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.risposta_aperta
    ADD CONSTRAINT risposta_aperte_pkey PRIMARY KEY (idr_a, username_s);
 N   ALTER TABLE ONLY public.risposta_aperta DROP CONSTRAINT risposta_aperte_pkey;
       public            postgres    false    215    215            �           2606    16482 (   risposte_multiple risposte_multiple_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.risposte_multiple
    ADD CONSTRAINT risposte_multiple_pkey PRIMARY KEY (idr_m, username_s);
 R   ALTER TABLE ONLY public.risposte_multiple DROP CONSTRAINT risposte_multiple_pkey;
       public            postgres    false    216    216            �           2606    16484    studente studente_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT studente_pkey PRIMARY KEY (username_s);
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT studente_pkey;
       public            postgres    false    219            �           2606    16486    test test_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id_test);
 8   ALTER TABLE ONLY public.test DROP CONSTRAINT test_pkey;
       public            postgres    false    211            �           2620    16487     correzione aggiorna_punteggiotot    TRIGGER     �   CREATE TRIGGER aggiorna_punteggiotot AFTER UPDATE OF voto_test ON public.correzione FOR EACH ROW EXECUTE FUNCTION public.aggiorna_punteggiotot();

ALTER TABLE public.correzione DISABLE TRIGGER aggiorna_punteggiotot;
 9   DROP TRIGGER aggiorna_punteggiotot ON public.correzione;
       public          postgres    false    209    209    222            �           2620    16488    risposta_aperta aggiorna_voto_a    TRIGGER     �   CREATE TRIGGER aggiorna_voto_a AFTER UPDATE OF punteggio_risa ON public.risposta_aperta FOR EACH ROW EXECUTE FUNCTION public.aggiorna_voto_a();

ALTER TABLE public.risposta_aperta DISABLE TRIGGER aggiorna_voto_a;
 8   DROP TRIGGER aggiorna_voto_a ON public.risposta_aperta;
       public          postgres    false    215    215    229            �           2620    16489    risposte_multiple assegna_bool    TRIGGER     �   CREATE TRIGGER assegna_bool AFTER INSERT OR UPDATE OF risposta_data ON public.risposte_multiple FOR EACH ROW EXECUTE FUNCTION public.assegna_bool();
 7   DROP TRIGGER assegna_bool ON public.risposte_multiple;
       public          postgres    false    216    216    246            �           2620    16490 +   insegnante controllo_credenziali_insegnante    TRIGGER     �   CREATE TRIGGER controllo_credenziali_insegnante AFTER INSERT ON public.insegnante FOR EACH ROW EXECUTE FUNCTION public.controllo_lunghezza_ins();
 D   DROP TRIGGER controllo_credenziali_insegnante ON public.insegnante;
       public          postgres    false    238    210            �           2620    16491 '   studente controllo_credenziali_studente    TRIGGER     �   CREATE TRIGGER controllo_credenziali_studente AFTER INSERT ON public.studente FOR EACH ROW EXECUTE FUNCTION public.controllo_lunghezza_stu();
 @   DROP TRIGGER controllo_credenziali_studente ON public.studente;
       public          postgres    false    239    219            �           2620    16492 +   risposte_multiple controllo_risposta_valida    TRIGGER     �   CREATE TRIGGER controllo_risposta_valida AFTER INSERT OR UPDATE OF risposta_data ON public.risposte_multiple FOR EACH ROW EXECUTE FUNCTION public.controllo_risposta();

ALTER TABLE public.risposte_multiple DISABLE TRIGGER controllo_risposta_valida;
 D   DROP TRIGGER controllo_risposta_valida ON public.risposte_multiple;
       public          postgres    false    241    216    216            �           2620    16493    test controllo_tempo    TRIGGER     �   CREATE TRIGGER controllo_tempo AFTER INSERT OR UPDATE OF tempo_svolgimento ON public.test FOR EACH ROW EXECUTE FUNCTION public.controllo_tempo();
 -   DROP TRIGGER controllo_tempo ON public.test;
       public          postgres    false    211    211    223            �           2620    16494    insegnante controllo_username_i    TRIGGER     �   CREATE TRIGGER controllo_username_i AFTER INSERT OR UPDATE OF username_i ON public.insegnante FOR EACH ROW EXECUTE FUNCTION public.controllo_username_i();
 8   DROP TRIGGER controllo_username_i ON public.insegnante;
       public          postgres    false    224    210    210            �           2620    16495    studente controllo_username_s    TRIGGER     �   CREATE TRIGGER controllo_username_s AFTER INSERT OR UPDATE OF username_s ON public.studente FOR EACH ROW EXECUTE FUNCTION public.controllo_username_s();
 6   DROP TRIGGER controllo_username_s ON public.studente;
       public          postgres    false    225    219    219            �           2620    16496 "   risposte_multiple somma_punteggiom    TRIGGER     �   CREATE TRIGGER somma_punteggiom AFTER UPDATE OF punteggio_rm ON public.risposte_multiple FOR EACH ROW EXECUTE FUNCTION public.somma_mul();
 ;   DROP TRIGGER somma_punteggiom ON public.risposte_multiple;
       public          postgres    false    216    216    242            �           2620    16497 (   correzione verifica_insegnantecorrezione    TRIGGER     �   CREATE TRIGGER verifica_insegnantecorrezione AFTER INSERT ON public.correzione FOR EACH ROW EXECUTE FUNCTION public.verifica_insegnantecorrezione();
 A   DROP TRIGGER verifica_insegnantecorrezione ON public.correzione;
       public          postgres    false    243    209            �           2620    16498    insegnante verifica_ipassword    TRIGGER        CREATE TRIGGER verifica_ipassword AFTER INSERT ON public.insegnante FOR EACH ROW EXECUTE FUNCTION public.verifica_ipassword();
 6   DROP TRIGGER verifica_ipassword ON public.insegnante;
       public          postgres    false    244    210            �           2620    16499    studente verifica_spassword    TRIGGER     }   CREATE TRIGGER verifica_spassword AFTER INSERT ON public.studente FOR EACH ROW EXECUTE FUNCTION public.verifica_spassword();
 4   DROP TRIGGER verifica_spassword ON public.studente;
       public          postgres    false    245    219            �           2606    16500 "   correzione correzione_id_test_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.correzione
    ADD CONSTRAINT correzione_id_test_fkey FOREIGN KEY (id_test) REFERENCES public.test(id_test);
 L   ALTER TABLE ONLY public.correzione DROP CONSTRAINT correzione_id_test_fkey;
       public          postgres    false    3242    211    209            �           2606    16505 %   correzione correzione_username_i_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.correzione
    ADD CONSTRAINT correzione_username_i_fkey FOREIGN KEY (username_i) REFERENCES public.insegnante(username_i);
 O   ALTER TABLE ONLY public.correzione DROP CONSTRAINT correzione_username_i_fkey;
       public          postgres    false    209    3240    210            �           2606    16510 %   correzione correzione_username_s_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.correzione
    ADD CONSTRAINT correzione_username_s_fkey FOREIGN KEY (username_s) REFERENCES public.studente(username_s);
 O   ALTER TABLE ONLY public.correzione DROP CONSTRAINT correzione_username_s_fkey;
       public          postgres    false    209    219    3252            �           2606    16515 '   quesito_aperto quiz_aperto_id_test_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.quesito_aperto
    ADD CONSTRAINT quiz_aperto_id_test_fkey FOREIGN KEY (id_test) REFERENCES public.test(id_test);
 Q   ALTER TABLE ONLY public.quesito_aperto DROP CONSTRAINT quiz_aperto_id_test_fkey;
       public          postgres    false    211    213    3242            �           2606    16520 +   quesito_multiplo quiz_multiplo_id_test_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.quesito_multiplo
    ADD CONSTRAINT quiz_multiplo_id_test_fkey FOREIGN KEY (id_test) REFERENCES public.test(id_test);
 U   ALTER TABLE ONLY public.quesito_multiplo DROP CONSTRAINT quiz_multiplo_id_test_fkey;
       public          postgres    false    3242    211    214            �           2606    16525 *   risposta_aperta risposta_aperte_idr_a_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposta_aperta
    ADD CONSTRAINT risposta_aperte_idr_a_fkey FOREIGN KEY (idr_a) REFERENCES public.quesito_aperto(id_a);
 T   ALTER TABLE ONLY public.risposta_aperta DROP CONSTRAINT risposta_aperte_idr_a_fkey;
       public          postgres    false    3244    215    213            �           2606    16530 /   risposta_aperta risposta_aperte_username_i_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposta_aperta
    ADD CONSTRAINT risposta_aperte_username_i_fkey FOREIGN KEY (username_i) REFERENCES public.insegnante(username_i);
 Y   ALTER TABLE ONLY public.risposta_aperta DROP CONSTRAINT risposta_aperte_username_i_fkey;
       public          postgres    false    210    215    3240            �           2606    16535 /   risposta_aperta risposta_aperte_username_s_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposta_aperta
    ADD CONSTRAINT risposta_aperte_username_s_fkey FOREIGN KEY (username_s) REFERENCES public.studente(username_s);
 Y   ALTER TABLE ONLY public.risposta_aperta DROP CONSTRAINT risposta_aperte_username_s_fkey;
       public          postgres    false    215    3252    219            �           2606    16540 .   risposte_multiple risposte_multiple_idr_m_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposte_multiple
    ADD CONSTRAINT risposte_multiple_idr_m_fkey FOREIGN KEY (idr_m) REFERENCES public.quesito_multiplo(id_m);
 X   ALTER TABLE ONLY public.risposte_multiple DROP CONSTRAINT risposte_multiple_idr_m_fkey;
       public          postgres    false    216    3246    214            �           2606    16545 3   risposte_multiple risposte_multiple_username_s_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposte_multiple
    ADD CONSTRAINT risposte_multiple_username_s_fkey FOREIGN KEY (username_s) REFERENCES public.studente(username_s);
 ]   ALTER TABLE ONLY public.risposte_multiple DROP CONSTRAINT risposte_multiple_username_s_fkey;
       public          postgres    false    216    219    3252            �           2606    16550    test test_username_i_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_username_i_fkey FOREIGN KEY (username_i) REFERENCES public.insegnante(username_i);
 C   ALTER TABLE ONLY public.test DROP CONSTRAINT test_username_i_fkey;
       public          postgres    false    211    3240    210            ]   �   x�����0�g�a�R�������Ki9iE���P��2D��|:�8q8D���K�b�b��`�U��4h��T#{X�	O�LV�qeglk����k�mk��<�t��D(#�<�6k���v�&+%~R�e�G�r�ZA|��+7Xq𨨴'7`*��u�KJ��k����c�x��i��fY�]�:�?      ^   +  x�5P�N1���AL &T]���Z����|�Eb��\h��q*"E����SR�j,Qa�,W]��Ĳ�^u&)��V��**T�T�3%�פ���LOl�	��.�!�1Ʈ�aJ#��H�Q8j��Ę�Z�xLqnԼ��!��v��IT�;��	�fc���&�覬E���i���G���?@w,�N��U+Yov�k�*�5�l"��b��N�
�]v���Q&#��aOY���8�Wt��3��'vт��"����Ʌ��h�!�y[t/��P"����%�g��k���>�B���q      `   �   x�E��j�0���)�Z�ꖽ�A�00:։����.ؾ?ݖ^rH����s�J�;�;�u@@u@x@G��0	C'��Cd������燿}�=cC�c%,��P��)v���~So�����Lb�:0#h��p�����U��4�*�[O�LQx�����6jB0Qg_I��$�}O�W�w� lL��A��8���ۡ�/�������i���u�;��N��9{{̲��;MA      a   �  x�uV�n�F<��b�S(��eپ�a/�#r���5|1`HHb]r�1�����z�]�碥�awuUw5OV�sn��ʼ*�'�.�wv�<8�%$����n�7V�mJ�5c�)��L���A���'2�����Qz�G'��)�#���lb�7쐅{���:	����<��D���d[�n�(�[]tk����k�ZN���ʶ�%ml�D��Hk|t���9{�l_�m���i�o����̻��@�鞌�}U(e�+Ҡ؁�z7��E�]ϝ���p�VJ2�)��ˈ���ݘ�-I��%	
�Y!���y���m V�Q����b��(��ʸ�&g�%�Y6n�-�9<g�6x�)RJ� �����˹zY�!������'D��Z�]�X�2�"|`�܈Iz/f�∞k��E��V�i"O�QuCK_���TP~��w��Q4U��qIM���WD z��C��v�8K+(%��1�B
�| �-^@�g��;�05%X��!�~�2QLrl����<���������d{4U66T�G���O���K�Deyt1��3�;�M�Sekt-�en0UR9H(!����E>[�tf�i� �Q���A�cnNVx��T߾4�u���\��)����@I�
�j;*c�QT��0:W�\4�'1���p��	�.�ϑ��?�2U��()i��5D��HT�<۷�M�
��U��z�R_* :0P�FV���׸IfD}R/��x�SȴȽ��
O���)�	��2_�q9�J���r]k˧&���G���I��g:��f��|鑌婂��(F��tp��+��h2$6s(�B��,�R�lt1�%	*��ް:����F	�$���FI���C=g`??,�z��[,��[s?Ԭ�Z�N0$��y�S�r���K�q-νy�.qk���d0�-4"Fƣ`0PIf�z���3�2�KA0*	4�:��Crh�&SO��Ԯ ��׺��4��>y�Z�\\��g/�3�;{��;3��uq�ü�Q�8���hk�� �b@K,�Hj}0X|��2f��Q��YgHG杉R�VZ��P�`��QW>2��=�{cvi�Jy�TO���jWX�.x����&���mt]B�����P�כy�'�(�U���S���W�o��Mj���E�����'6�z�O�?�{yk=�S��	�ȭ����8���"�z�����\��v�S�҅���
d�(5�h_cћ�)�u#4�8roڟ\��`^���o}�|���/�Q�Sp��]����8��Y��%ͬW���Wf-Q��ve�]�_#�~���4&#�[t���R*������̼zx������{�����n����������[{wg?�c?��}��{x�D������~�x���n���7�������_���F      b   �  x��V�nE>������X^��p3&HH��_jgj�%z�����O\yހ37�~���z�Y;"@����tWW}=۳m7�-�7(ϖ˘�S�%k.�}�IH#M6�7B�i��-r���=/L<P�4H�4i�b�� 揍f+��PI���u$
$uT�-
�ݟ�����-g�i����[�=ٞ}��\�gQ��û_)?P�I'���A��Eb��	��A6ti�9�%/B�]ҺL>ؠ5|�B=�A�(��O?=���Jv%{Un$�OsP,��*�� 4&�8�
{9l��"]����+b� +�=@�0��;MKk�JB=����#~��1�U�Gg)�I�e%�Ƚ�P�iƓAG-�Em�'m�n�����wķW���ZWA:}U�i�1bTG�u�ma�V�l����Ag#*���YZ'x@�E�����{]A3�q=*����V1a��ޢ3�E_�~���7�w\�!u��d@��'���o<��7�Mq�&/libP6kl�
5z�n�׈�����x�Tu��3` ��#eeG�b8�	o���MS���Ey��F����N�o�5�x���d<I��M�W����)����ĩ���oպAj��&ư��K�{�yi_��@X<���/F�𕬱^�L�&ps�3��h��(��t~҅���K.�z@��\������.�G��M����Ҝ�c�	�ʽ�l�?�E��s�uq��Q�[��u�14�����T�� ���6a�'~nϓ[�i�ꯣ��c�!��m�8�!!��5,�H����2a��~�x�|�В[����#&~H�ˍl`7�sO��O��	FE����#:st�4K['k���ǧY��ÂG*p� )p�$>[�4��Ԩ���y�}�U�v��@�u���QB�p�,���R�����S�j��]�O�)߻ �\"���'����A߀e0���u�A�Kl@H�߅H�Fq�C�w�Fi���+ �?m�������=<ꝸ���a�}�e{��T�\uY�u��<(���Ŏ7�}v��H<P�a���&��i��l��Qc@h��v��c�A�yۀ�y{qԡ�Hpi`� ~?�3��fϵ�A��8�zhtxs=�ժ��k~{ڸpֻ�0���?��e�<0��ؐ���hXo���H{��#L����n���#��E�u����m��/\�ǽם�\�����ZՖJ      c   ;  x����n�@���)����ޖ�`V]����*7��RȐH��g���*�b~��7�;���8:�'zު�sq���L��k���Q<J�x���T�CY�������H(.s�F���R֏��<���j?�L��
W,g�2�ZY��a?�V)ʇXT�iȉ �C��2Z�kI�3)�x�I�{&�baQ��|)�Ñ�S@�L&�Rz)�р��u�[gE��WK!�z�n� ���ƥ��J(�r��s�	
4�-�R�Cu� �I]j�'к��"p橁�1y�@��e�R�j��굤���bcGz�vK�O��A���曶���Zn�1�:�z�sE�*�,Ͻ��N?�eP�:̴e���5Q����*FdWl�I���1)XH�%TGϯ���n�ԞҘ�]x��Y�r��;��B\&��8n�iZ�9�S��Nn:���6vƚA�

��9kUSb��d�m�fp���hw%�\s9�[�{���Z\G�h�P��ڿѷ����xz��Q��s��Vtd�Z�����+�=�ZX��hv[�T�Vu���y{"7��ϣ��˟9      d   �   x�EP�j�0<�S�����y��B��^&��
b)�N ��ڻ-�`�I3c/�y�Q�X�>2m�6�^��.Ku��z�Ѩqr9��J�j<!0�X�,s?$��R[���DD�� �F�?�n/t#� eET:��l~�sũVf7���Gh�S\�y�bz��Xz���˦��4q۶Tk��OZ^5NU!�5z-�9刺�St���J#�Lo��b,)rZ�Y`�53��%���s?Q�}=      _     x�}�Ao�@��ï�_�,�`�[B$�GU��r�ĝ
f�.�ֿ��Q��ur��|���z
��� <h`�*��U*u�R��.�w޿��E�b]C�|b�I2��EcN��s�F��ĚINdm�n0k�YACc�_�?X*l�h��mΉ�v(�����9
qYh����ը����-v�m�(�q9́Wc]��:�b�"���1f���p���M����%�h�h�w�4��̲O<Ϧi��4�����@qp���n��K��G���2-a�(M ��~�8��_��:<�Ƚ���={`}?�X�n�|���+�{�{=s��_�)�\�U�_�g
��)��#uZ<1V�n67�2Z����mo��հ�N�<�$I���     