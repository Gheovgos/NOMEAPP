PGDMP     :    %    	            z            Manabi    14.1    14.1 B    N           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            O           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            P           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            Q           1262    16394    Manabi    DATABASE     d   CREATE DATABASE "Manabi" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Italian_Italy.1252';
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
       public         heap    postgres    false            �            1259    16425    quesito_aperto    TABLE     ,  CREATE TABLE public.quesito_aperto (
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
       public         heap    postgres    false            �            1259    16459    studente    TABLE     �   CREATE TABLE public.studente (
    username_s character varying(25) NOT NULL,
    password_s character varying(25) NOT NULL,
    nome character varying(25),
    cognome character varying(25),
    punteggio_tot double precision DEFAULT 0
);
    DROP TABLE public.studente;
       public         heap    postgres    false            �            1259    16417    test    TABLE     K  CREATE TABLE public.test (
    id_test integer NOT NULL,
    username_i character varying(25) NOT NULL,
    nome_test character varying(200) NOT NULL,
    tempo_svolgimento time without time zone,
    materia_test character varying(250),
    descrizione character varying(1000) DEFAULT 'Nessuna descrizione.'::character varying
);
    DROP TABLE public.test;
       public         heap    postgres    false            D          0    16409 
   correzione 
   TABLE DATA           Z   COPY public.correzione (username_i, username_s, id_test, corretto, voto_test) FROM stdin;
    public          postgres    false    209   u       E          0    16414 
   insegnante 
   TABLE DATA           K   COPY public.insegnante (username_i, password_i, nome, cognome) FROM stdin;
    public          postgres    false    210   R�       G          0    16425    quesito_aperto 
   TABLE DATA           ^   COPY public.quesito_aperto (id_a, id_test, punteggio_min, punteggio_max, domanda) FROM stdin;
    public          postgres    false    212   ��       H          0    16429    quesito_multiplo 
   TABLE DATA           �   COPY public.quesito_multiplo (id_m, id_test, punteggio_corretto, punteggio_errato, domanda, r_unoc, r_due, r_tre, r_quattro, r_cinque) FROM stdin;
    public          postgres    false    213   d�       I          0    16437    risposta_aperta 
   TABLE DATA           q   COPY public.risposta_aperta (idr_a, username_s, username_i, risposta_data, commento, punteggio_risa) FROM stdin;
    public          postgres    false    214   ��       J          0    16444    risposte_multiple 
   TABLE DATA           e   COPY public.risposte_multiple (idr_m, username_s, risposta_data, corretta, punteggio_rm) FROM stdin;
    public          postgres    false    215   �       K          0    16459    studente 
   TABLE DATA           X   COPY public.studente (username_s, password_s, nome, cognome, punteggio_tot) FROM stdin;
    public          postgres    false    216   2�       F          0    16417    test 
   TABLE DATA           l   COPY public.test (id_test, username_i, nome_test, tempo_svolgimento, materia_test, descrizione) FROM stdin;
    public          postgres    false    211   4�       �           2606    16472    correzione correzione_pkey 
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
       public            postgres    false    212            �           2606    16478 #   quesito_multiplo quiz_multiplo_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.quesito_multiplo
    ADD CONSTRAINT quiz_multiplo_pkey PRIMARY KEY (id_m);
 M   ALTER TABLE ONLY public.quesito_multiplo DROP CONSTRAINT quiz_multiplo_pkey;
       public            postgres    false    213            �           2606    16480 $   risposta_aperta risposta_aperte_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.risposta_aperta
    ADD CONSTRAINT risposta_aperte_pkey PRIMARY KEY (idr_a, username_s);
 N   ALTER TABLE ONLY public.risposta_aperta DROP CONSTRAINT risposta_aperte_pkey;
       public            postgres    false    214    214            �           2606    16482 (   risposte_multiple risposte_multiple_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.risposte_multiple
    ADD CONSTRAINT risposte_multiple_pkey PRIMARY KEY (idr_m, username_s);
 R   ALTER TABLE ONLY public.risposte_multiple DROP CONSTRAINT risposte_multiple_pkey;
       public            postgres    false    215    215            �           2606    16484    studente studente_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT studente_pkey PRIMARY KEY (username_s);
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT studente_pkey;
       public            postgres    false    216            �           2606    16486    test test_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id_test);
 8   ALTER TABLE ONLY public.test DROP CONSTRAINT test_pkey;
       public            postgres    false    211            �           2620    16487     correzione aggiorna_punteggiotot    TRIGGER     �   CREATE TRIGGER aggiorna_punteggiotot AFTER UPDATE OF voto_test ON public.correzione FOR EACH ROW EXECUTE FUNCTION public.aggiorna_punteggiotot();

ALTER TABLE public.correzione DISABLE TRIGGER aggiorna_punteggiotot;
 9   DROP TRIGGER aggiorna_punteggiotot ON public.correzione;
       public          postgres    false    209    217    209            �           2620    16488    risposta_aperta aggiorna_voto_a    TRIGGER     �   CREATE TRIGGER aggiorna_voto_a AFTER UPDATE OF punteggio_risa ON public.risposta_aperta FOR EACH ROW EXECUTE FUNCTION public.aggiorna_voto_a();

ALTER TABLE public.risposta_aperta DISABLE TRIGGER aggiorna_voto_a;
 8   DROP TRIGGER aggiorna_voto_a ON public.risposta_aperta;
       public          postgres    false    224    214    214            �           2620    16489    risposte_multiple assegna_bool    TRIGGER     �   CREATE TRIGGER assegna_bool AFTER INSERT OR UPDATE OF risposta_data ON public.risposte_multiple FOR EACH ROW EXECUTE FUNCTION public.assegna_bool();
 7   DROP TRIGGER assegna_bool ON public.risposte_multiple;
       public          postgres    false    241    215    215            �           2620    16490 +   insegnante controllo_credenziali_insegnante    TRIGGER     �   CREATE TRIGGER controllo_credenziali_insegnante AFTER INSERT ON public.insegnante FOR EACH ROW EXECUTE FUNCTION public.controllo_lunghezza_ins();
 D   DROP TRIGGER controllo_credenziali_insegnante ON public.insegnante;
       public          postgres    false    210    233            �           2620    16491 '   studente controllo_credenziali_studente    TRIGGER     �   CREATE TRIGGER controllo_credenziali_studente AFTER INSERT ON public.studente FOR EACH ROW EXECUTE FUNCTION public.controllo_lunghezza_stu();
 @   DROP TRIGGER controllo_credenziali_studente ON public.studente;
       public          postgres    false    216    234            �           2620    16492 +   risposte_multiple controllo_risposta_valida    TRIGGER     �   CREATE TRIGGER controllo_risposta_valida AFTER INSERT OR UPDATE OF risposta_data ON public.risposte_multiple FOR EACH ROW EXECUTE FUNCTION public.controllo_risposta();

ALTER TABLE public.risposte_multiple DISABLE TRIGGER controllo_risposta_valida;
 D   DROP TRIGGER controllo_risposta_valida ON public.risposte_multiple;
       public          postgres    false    236    215    215            �           2620    16493    test controllo_tempo    TRIGGER     �   CREATE TRIGGER controllo_tempo AFTER INSERT OR UPDATE OF tempo_svolgimento ON public.test FOR EACH ROW EXECUTE FUNCTION public.controllo_tempo();
 -   DROP TRIGGER controllo_tempo ON public.test;
       public          postgres    false    211    211    218            �           2620    16494    insegnante controllo_username_i    TRIGGER     �   CREATE TRIGGER controllo_username_i AFTER INSERT OR UPDATE OF username_i ON public.insegnante FOR EACH ROW EXECUTE FUNCTION public.controllo_username_i();
 8   DROP TRIGGER controllo_username_i ON public.insegnante;
       public          postgres    false    210    210    219            �           2620    16495    studente controllo_username_s    TRIGGER     �   CREATE TRIGGER controllo_username_s AFTER INSERT OR UPDATE OF username_s ON public.studente FOR EACH ROW EXECUTE FUNCTION public.controllo_username_s();
 6   DROP TRIGGER controllo_username_s ON public.studente;
       public          postgres    false    216    220    216            �           2620    16496 "   risposte_multiple somma_punteggiom    TRIGGER     �   CREATE TRIGGER somma_punteggiom AFTER UPDATE OF punteggio_rm ON public.risposte_multiple FOR EACH ROW EXECUTE FUNCTION public.somma_mul();
 ;   DROP TRIGGER somma_punteggiom ON public.risposte_multiple;
       public          postgres    false    215    237    215            �           2620    16497 (   correzione verifica_insegnantecorrezione    TRIGGER     �   CREATE TRIGGER verifica_insegnantecorrezione AFTER INSERT ON public.correzione FOR EACH ROW EXECUTE FUNCTION public.verifica_insegnantecorrezione();
 A   DROP TRIGGER verifica_insegnantecorrezione ON public.correzione;
       public          postgres    false    209    238            �           2620    16498    insegnante verifica_ipassword    TRIGGER        CREATE TRIGGER verifica_ipassword AFTER INSERT ON public.insegnante FOR EACH ROW EXECUTE FUNCTION public.verifica_ipassword();
 6   DROP TRIGGER verifica_ipassword ON public.insegnante;
       public          postgres    false    239    210            �           2620    16499    studente verifica_spassword    TRIGGER     }   CREATE TRIGGER verifica_spassword AFTER INSERT ON public.studente FOR EACH ROW EXECUTE FUNCTION public.verifica_spassword();
 4   DROP TRIGGER verifica_spassword ON public.studente;
       public          postgres    false    216    240            �           2606    16500 "   correzione correzione_id_test_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.correzione
    ADD CONSTRAINT correzione_id_test_fkey FOREIGN KEY (id_test) REFERENCES public.test(id_test);
 L   ALTER TABLE ONLY public.correzione DROP CONSTRAINT correzione_id_test_fkey;
       public          postgres    false    3222    211    209            �           2606    16505 %   correzione correzione_username_i_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.correzione
    ADD CONSTRAINT correzione_username_i_fkey FOREIGN KEY (username_i) REFERENCES public.insegnante(username_i);
 O   ALTER TABLE ONLY public.correzione DROP CONSTRAINT correzione_username_i_fkey;
       public          postgres    false    3220    210    209            �           2606    16510 %   correzione correzione_username_s_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.correzione
    ADD CONSTRAINT correzione_username_s_fkey FOREIGN KEY (username_s) REFERENCES public.studente(username_s);
 O   ALTER TABLE ONLY public.correzione DROP CONSTRAINT correzione_username_s_fkey;
       public          postgres    false    209    216    3232            �           2606    16515 '   quesito_aperto quiz_aperto_id_test_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.quesito_aperto
    ADD CONSTRAINT quiz_aperto_id_test_fkey FOREIGN KEY (id_test) REFERENCES public.test(id_test);
 Q   ALTER TABLE ONLY public.quesito_aperto DROP CONSTRAINT quiz_aperto_id_test_fkey;
       public          postgres    false    3222    212    211            �           2606    16520 +   quesito_multiplo quiz_multiplo_id_test_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.quesito_multiplo
    ADD CONSTRAINT quiz_multiplo_id_test_fkey FOREIGN KEY (id_test) REFERENCES public.test(id_test);
 U   ALTER TABLE ONLY public.quesito_multiplo DROP CONSTRAINT quiz_multiplo_id_test_fkey;
       public          postgres    false    3222    213    211            �           2606    16525 *   risposta_aperta risposta_aperte_idr_a_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposta_aperta
    ADD CONSTRAINT risposta_aperte_idr_a_fkey FOREIGN KEY (idr_a) REFERENCES public.quesito_aperto(id_a);
 T   ALTER TABLE ONLY public.risposta_aperta DROP CONSTRAINT risposta_aperte_idr_a_fkey;
       public          postgres    false    3224    212    214            �           2606    16530 /   risposta_aperta risposta_aperte_username_i_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposta_aperta
    ADD CONSTRAINT risposta_aperte_username_i_fkey FOREIGN KEY (username_i) REFERENCES public.insegnante(username_i);
 Y   ALTER TABLE ONLY public.risposta_aperta DROP CONSTRAINT risposta_aperte_username_i_fkey;
       public          postgres    false    214    210    3220            �           2606    16535 /   risposta_aperta risposta_aperte_username_s_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposta_aperta
    ADD CONSTRAINT risposta_aperte_username_s_fkey FOREIGN KEY (username_s) REFERENCES public.studente(username_s);
 Y   ALTER TABLE ONLY public.risposta_aperta DROP CONSTRAINT risposta_aperte_username_s_fkey;
       public          postgres    false    214    3232    216            �           2606    16540 .   risposte_multiple risposte_multiple_idr_m_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposte_multiple
    ADD CONSTRAINT risposte_multiple_idr_m_fkey FOREIGN KEY (idr_m) REFERENCES public.quesito_multiplo(id_m);
 X   ALTER TABLE ONLY public.risposte_multiple DROP CONSTRAINT risposte_multiple_idr_m_fkey;
       public          postgres    false    213    3226    215            �           2606    16545 3   risposte_multiple risposte_multiple_username_s_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.risposte_multiple
    ADD CONSTRAINT risposte_multiple_username_s_fkey FOREIGN KEY (username_s) REFERENCES public.studente(username_s);
 ]   ALTER TABLE ONLY public.risposte_multiple DROP CONSTRAINT risposte_multiple_username_s_fkey;
       public          postgres    false    215    216    3232            �           2606    16550    test test_username_i_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_username_i_fkey FOREIGN KEY (username_i) REFERENCES public.insegnante(username_i);
 C   ALTER TABLE ONLY public.test DROP CONSTRAINT test_username_i_fkey;
       public          postgres    false    3220    211    210            D   �   x�u��j�0���Ì�M)=�k`�V[�m�	m�~"4�����~}R���=��qF�.#**�)?�P�?�Y"*��	��K�'������+P����{�(����l#��<�αd�T�T�+�lG)��\����/�~q���E3WQ�^ N�񣘃@�x��%�M���/��~�j�5�=���y�܁)���V����/��{      E   +  x�5P�N1���AL &T]���Z����|�Eb��\h��q*"E����SR�j,Qa�,W]��Ĳ�^u&)��V��**T�T�3%�פ���LOl�	��.�!�1Ʈ�aJ#��H�Q8j��Ę�Z�xLqnԼ��!��v��IT�;��	�fc���&�覬E���i���G���?@w,�N��U+Yov�k�*�5�l"��b��N�
�]v���Q&#��aOY���8�Wt��3��'vт��"����Ʌ��h�!�y[t/��P"����%�g��k���>�B���q      G   �  x�E�ώ�0����[��4Yi��Yrb�Iz��^2ؔ?9��}��ɮ���=����hq�
�U�.���D<�|���rq�sVJ�r�3+�(�5��+Y�a�Z�����c"�T�	H�5���R�|B{^�O2�J�f�#��T)�<86ԴyZz��g�0��R,u�`�^�|�%���(y.����}"��?=3���,�@�4Sd���)��B��s�4 `�q��4݁�͠mc�]��iM��Bu3Л]�`D�m�t���5���E��'s�q�ٞ������k�hhf��` muC3N�J?�N�w-�M��`�ܨ�`������Yh5���8��^������@Mn��};����yz��;}�^��Ä���kJx�ܛ+�bt�{6M���%���}5[�E���3�J��`M!�Z2,L?���X�C��K���'��      H   8  x�uVMs�6=ÿb�S;�t$)�E�+
5	0 �D�\4��hƕZ��!��O�?����d%M/H�����[�G���P�j�^��b��Tij��5��W�Tպ��so��x��J/B��8���j�)��X����-���R92�����rW3C��hx1ܹ�KglR�"ȹ���{�T�]�6�xUz=3���v��dB�m1Ue��|�瞹y�\�r��"þɝ�ʚG<�\e���,�꽕�����5�n9DC�S�VbG���NW���r]��Uz���Pi��Y��l�/争FN���	�QB ZV�d,�e#,̼����0�Q�:���w��Ň�6S �w���m�nld�! @X�~���}�n6��J�@�����q�}iľ
��1�&s*Ȼp���zL)�7iD�l��:�®-��$�>$%����o[G�W��LI4�����[PZg��=�����! r�x@A,� {�� �J*y����djX���	|���wJ�WR���A{��O�3U(Nh�9�_����dS�F�^�[/(7�G#G|��d��		�F.�]�)x�}@�)ɫ�J{������N���f<��3�z��R��>�F\�i)ǚ�{����`a��@IY4Zg��E���Ti�^8�d�~Yp��C�/���?��%�K�B��k3G R�D ��3�Cn�U8>K�5\���QD	Rl�-�����U��\ZJ$׈�IOA�@�!�D<��{�h���(J�
�p���͆u�(��ԏ<̟�JJ'��h���@5�*���xt�%�E������~��CW�!6	f�P.��.�Y�	m��F3Ȱp�
�'s��/���So!��;�ɛ�8�� �447V+ȏط���Q{��&{3S���\bMn;�#'y*](t�vߗ2�
�{�j��y���P[V����ᫌeMRWZ%�D-����r�g�a��Í�!L2�4+M�
D +����&b 6gf������`1�⻽�g��Z��M�� ���TƱ_�(}]Υ4� doQ��:�H_ȸ��U�(�3QzHZ�k�]�M�02�hB҂�#�|S��'���^��0�KL��f`m���m��ԩQQd��d�
��7JZP��h?���r��e�����OIxe�i�A�E���_� �ȧ���^���V����b�V��ϧt�7��`*w��> �bj������?k�ԟ�|({��!.P�$��)M[�t�(h�H5jOo0�U���R����\��Wm�Ԙ�:��U�����dOV�Bvڍ(/�)4EWK�I��|��������ҿT�u��j���˘��,Cg�b���o��0�:�T/�����݊~�-�����Ên������nִ�n��?�a�yXo�p���ؚ��n�������mXm�J�i�k��zq���Ɨ���ï���Vۇ��ؾX>l�٭�׷+9s���|��_�[o�@�"]/O&/���s1j6��ӊ>���͖��?�6𿾣�UJd�������v�W��r�e�&�Q��c�F�x�R�{wxz��Iam�'u������R� �      I   V  x��V�nE>������X���17��	+A�ŗڙ��DO��?��+��p���o�U�ػ��(?��TWW}?U�>X7����)��5�A�K��6�8:�@�vJ�#�4��4p���-OL�Q	Թ�� ���$�S{�4jv)9�Q'�D�\Bq�	����=���5%وw�����[<iF��3�z��?(e�P<�Q���N��Ʌ\"�υ�[ѩzdgO�<9�R����0��
��spԢ������uL��q*��|�"9�a􂠕E�	��07�4�����\�K�����
X���h������H��k� �E�s������VF�
p4�B\�$�U/+Jn�^2�#��$��AE�a|&����_���Eh#I��V�Z���s�ZP��0��=C��zdB(��J��X
�x%�"p�8D%�2_�b�p�*��#}��Y̎��A����ﲃ~Σ�W�7�� 1�Ǩ@�������<l�9ٚ�
Ev�X���l�P�J���\w������zEWe��K` ^�=%aC��[�\�7K�xU�c�� ��4�G����u���Yݮ��+�q������j{�G��=��V7�&�-������3��עM�Jr��f7��w��e!�a�`yj_�N�+7���b��W#>��A	J��2�C�7�/�o�h2o���+ x��V[�ٵ�F�F�Ӗ��R�ޢ���K��G��u���&ʘ��$�Al���2$\������C�G�וVϠ
�X�L*(��\�.O�ޖ����_K*��]ds��Á	���"-��Q��˸�y|�����C�f�z���x�@�w8�f�3����F� �!@�=Tf��ir5��XC�~|ܽ|�S0r.��V���e0כ"���0E��*��� E�g���G����R7	7�rJ����z�F��R�
~�(F�Ҧ|kV xr��?��<�W���E?�e0�P�5�A�Il@H��BL�J��e�ϩ�zW/h��V8 �c����6/����FP��U$6>+f�O.��g7{SA����΃�lN��ෳ��J�B��P%�󚰏�1tG}��{-s׆�U7�j�ڠ������U$X��;ۏ�b-��ڌn'�6��vǣ`��z��0�o�6&�yw/ͺx�7Fc}Y�;(6Td���6�L�t)�~�I����K3�Xߑ���@k����)�շW�u_4{G��{��k�0���S�>~~��[n����{����\_�ꁧ�G��aO�	{�o|o
�dꉣ'���2��#�?�r�B�{��L�������O��5�`���`�u�`�-�݀{��]�^�����F]����� L9{      J     x���Qo�0ǟç��M	��f�#xu��vX����E�PQ:i}�g��%i�i�D����ߝ�΁����H��~[x�ff3&c)e�o�?|��{<�ź|z,�a�mv/��e�-���n%=�P��Y�t,^�}2��bK\20ӆA���1j��+���݁Aɬ��(\Z�h�E���	� 8���|ʙ@P��D%\E��:`(�Nx����@+@bf���RĲJ/Z.� �+�T��Ô:Syi�Ƈ�Hh_i5Kg�2��#���� �I51qy"�z5��"D,�R�D�� 0IP���蕠������sW���]��8t��~�����4Z�r���9#&�J)K�ܺTW��>�U1eX��K�$Q�$��U�ȮX�7�e�3�:I��u�m��~~=�u{Lmv�a��h�▻t�����P&�߂#4H}FU�n	���x�ڮ\[�(��,O�ΪFU��n-]z�4MI�f���1��D�������w�.+j�ݗ��_�����x�xI��霦�%1��T�ʞ/8o����yGǰ�����<�w߷�#�1L)��!�F�p2��W@����`N�X*w�M�w�z��9������N����e,5:
�LZ*�z'P)��D��)&�q�V��w�
���Q���⫎�f�,WR]TӗN��jf�{Ĭ�KU�.�N�ݪ8zag��P�]���ez꽩
�����&����\�7���]���/��m�,k�m��#��z���/2^��k��-}�~0�"<�      K   �   x�M�Ok�0����:�s����P촋�(������O?9�`�����0�k�P8Q_Xe�x�v���n�\QY�Ǒ���:��|{�B�e� �h�)L(������o��Xؒ'�.�K��Q=I!0�5 |r$5�Y�㤹�D�d�f�`M��W��a��NX�,%��҈��M#���;1�z�\�fn��Y�
�C5���7%�8p�0a�����X�S;�g��'�������{H      F     x����r�0���S���6&5��v04��\{qw��R�f�<}W�0nc�iO|H��H���#��Yjّ-X-�bc`������Xd��<�s�ϫ_-�z�Y%�����I��#�F�G2j%Y��s�^6���e���"m�!�*����1�7�F-LM�`�9�4�č�WƧJ>�'߲�	�T"W�B�e!��4�dse�q�
�.�� ��m�z�����N�0����g��K�[��t2`ę�fءoa��[��[O� *��=OnH�箨��������G�G���CΎ�wᄪ�ʘtg&�a^́i�'سk�p�(OF�/U�]�٥�Dr�����'�S��`�W��
$�m;S#�B���(�s�$cK�"E�tJ�6{ް�0�K�ǀ,�Z���(�%mG{�ш7�C�Q�D�8J�l��yv�i����-"�o܏(�l��zLp+ބ���������ȍ&���.��<�阱g,ؖ�f��{S�:�9���,z�DQ��     