PGDMP  %                    }            form_generator    16.9    16.9 U    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    25319    form_generator    DATABASE     �   CREATE DATABASE form_generator WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_India.1252';
    DROP DATABASE form_generator;
                postgres    false            �            1255    26646 "   update_events_form_reg_timestamp()    FUNCTION       CREATE FUNCTION public.update_events_form_reg_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                    BEGIN
                        NEW.updated_at = NOW();
                        RETURN NEW;
                    END;
                    $$;
 9   DROP FUNCTION public.update_events_form_reg_timestamp();
       public          postgres    false            �            1255    25689    update_schools_form_timestamp()    FUNCTION       CREATE FUNCTION public.update_schools_form_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                        BEGIN
                            NEW.updated_at = NOW();
                            RETURN NEW;
                        END;
                        $$;
 6   DROP FUNCTION public.update_schools_form_timestamp();
       public          postgres    false            �            1255    25678    update_teacher_form_timestamp()    FUNCTION       CREATE FUNCTION public.update_teacher_form_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                        BEGIN
                            NEW.updated_at = NOW();
                            RETURN NEW;
                        END;
                        $$;
 6   DROP FUNCTION public.update_teacher_form_timestamp();
       public          postgres    false            �            1259    27454    child_relationships    TABLE     �  CREATE TABLE public.child_relationships (
    id integer NOT NULL,
    parent_id integer NOT NULL,
    child_form1 character varying(255) NOT NULL,
    record_id1 integer NOT NULL,
    child_form2 character varying(255) NOT NULL,
    record_id2 integer NOT NULL,
    relationship_type character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 '   DROP TABLE public.child_relationships;
       public         heap    postgres    false            �            1259    27453    child_relationships_id_seq    SEQUENCE     �   CREATE SEQUENCE public.child_relationships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.child_relationships_id_seq;
       public          postgres    false    223            �           0    0    child_relationships_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.child_relationships_id_seq OWNED BY public.child_relationships.id;
          public          postgres    false    222            �            1259    27504    company_form    TABLE     �   CREATE TABLE public.company_form (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    name character varying(255),
    parent_id integer
);
     DROP TABLE public.company_form;
       public         heap    postgres    false            �            1259    27503    company_form_id_seq    SEQUENCE     �   CREATE SEQUENCE public.company_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.company_form_id_seq;
       public          postgres    false    231            �           0    0    company_form_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.company_form_id_seq OWNED BY public.company_form.id;
          public          postgres    false    230            �            1259    27425    form_permissions    TABLE     �   CREATE TABLE public.form_permissions (
    id integer NOT NULL,
    form_id integer NOT NULL,
    user_id integer NOT NULL,
    can_view boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false
);
 $   DROP TABLE public.form_permissions;
       public         heap    postgres    false            �            1259    27424    form_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.form_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.form_permissions_id_seq;
       public          postgres    false    220            �           0    0    form_permissions_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.form_permissions_id_seq OWNED BY public.form_permissions.id;
          public          postgres    false    219            �            1259    27407    forms    TABLE     M  CREATE TABLE public.forms (
    id integer NOT NULL,
    form_name character varying(255) NOT NULL,
    fields jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    share_token character varying(255)
);
    DROP TABLE public.forms;
       public         heap    postgres    false            �            1259    27406    forms_id_seq    SEQUENCE     �   CREATE SEQUENCE public.forms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.forms_id_seq;
       public          postgres    false    218            �           0    0    forms_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.forms_id_seq OWNED BY public.forms.id;
          public          postgres    false    217            �            1259    27512    personl_info    TABLE     �   CREATE TABLE public.personl_info (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    name character varying(255),
    age character varying(255)
);
     DROP TABLE public.personl_info;
       public         heap    postgres    false            �            1259    27511    personl_info_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personl_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.personl_info_id_seq;
       public          postgres    false    233            �           0    0    personl_info_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.personl_info_id_seq OWNED BY public.personl_info.id;
          public          postgres    false    232            �            1259    27446    roles    TABLE     h   CREATE TABLE public.roles (
    name character varying(50) NOT NULL,
    permissions text[] NOT NULL
);
    DROP TABLE public.roles;
       public         heap    postgres    false            �            1259    27466    school_form    TABLE     �   CREATE TABLE public.school_form (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    name character varying(255)
);
    DROP TABLE public.school_form;
       public         heap    postgres    false            �            1259    27465    school_form_id_seq    SEQUENCE     �   CREATE SEQUENCE public.school_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.school_form_id_seq;
       public          postgres    false    225            �           0    0    school_form_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.school_form_id_seq OWNED BY public.school_form.id;
          public          postgres    false    224            �            1259    27474    student_form    TABLE     �   CREATE TABLE public.student_form (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    name character varying(255),
    parent_id integer
);
     DROP TABLE public.student_form;
       public         heap    postgres    false            �            1259    27473    student_form_id_seq    SEQUENCE     �   CREATE SEQUENCE public.student_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.student_form_id_seq;
       public          postgres    false    227            �           0    0    student_form_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.student_form_id_seq OWNED BY public.student_form.id;
          public          postgres    false    226            �            1259    27487    teacher_form    TABLE     �   CREATE TABLE public.teacher_form (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    name character varying(255),
    parent_id integer
);
     DROP TABLE public.teacher_form;
       public         heap    postgres    false            �            1259    27486    teacher_form_id_seq    SEQUENCE     �   CREATE SEQUENCE public.teacher_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.teacher_form_id_seq;
       public          postgres    false    229            �           0    0    teacher_form_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.teacher_form_id_seq OWNED BY public.teacher_form.id;
          public          postgres    false    228            �            1259    27395    users    TABLE     �  CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    email character varying(255),
    phone character varying(20),
    otp character varying(6),
    otp_expires_at timestamp without time zone
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    27394    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    216            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    215            �           2604    27457    child_relationships id    DEFAULT     �   ALTER TABLE ONLY public.child_relationships ALTER COLUMN id SET DEFAULT nextval('public.child_relationships_id_seq'::regclass);
 E   ALTER TABLE public.child_relationships ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    222    223            �           2604    27507    company_form id    DEFAULT     r   ALTER TABLE ONLY public.company_form ALTER COLUMN id SET DEFAULT nextval('public.company_form_id_seq'::regclass);
 >   ALTER TABLE public.company_form ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    231    231            �           2604    27428    form_permissions id    DEFAULT     z   ALTER TABLE ONLY public.form_permissions ALTER COLUMN id SET DEFAULT nextval('public.form_permissions_id_seq'::regclass);
 B   ALTER TABLE public.form_permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219    220            �           2604    27410    forms id    DEFAULT     d   ALTER TABLE ONLY public.forms ALTER COLUMN id SET DEFAULT nextval('public.forms_id_seq'::regclass);
 7   ALTER TABLE public.forms ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    218    218            �           2604    27515    personl_info id    DEFAULT     r   ALTER TABLE ONLY public.personl_info ALTER COLUMN id SET DEFAULT nextval('public.personl_info_id_seq'::regclass);
 >   ALTER TABLE public.personl_info ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232    233            �           2604    27469    school_form id    DEFAULT     p   ALTER TABLE ONLY public.school_form ALTER COLUMN id SET DEFAULT nextval('public.school_form_id_seq'::regclass);
 =   ALTER TABLE public.school_form ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    27477    student_form id    DEFAULT     r   ALTER TABLE ONLY public.student_form ALTER COLUMN id SET DEFAULT nextval('public.student_form_id_seq'::regclass);
 >   ALTER TABLE public.student_form ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227            �           2604    27490    teacher_form id    DEFAULT     r   ALTER TABLE ONLY public.teacher_form ALTER COLUMN id SET DEFAULT nextval('public.teacher_form_id_seq'::regclass);
 >   ALTER TABLE public.teacher_form ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228    229            �           2604    27398    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    216    216            �          0    27454    child_relationships 
   TABLE DATA           �   COPY public.child_relationships (id, parent_id, child_form1, record_id1, child_form2, record_id2, relationship_type, created_at) FROM stdin;
    public          postgres    false    223   Xg       �          0    27504    company_form 
   TABLE DATA           G   COPY public.company_form (id, created_at, name, parent_id) FROM stdin;
    public          postgres    false    231   h       }          0    27425    form_permissions 
   TABLE DATA           `   COPY public.form_permissions (id, form_id, user_id, can_view, can_edit, can_delete) FROM stdin;
    public          postgres    false    220    h       {          0    27407    forms 
   TABLE DATA           g   COPY public.forms (id, form_name, fields, created_at, updated_at, created_by, share_token) FROM stdin;
    public          postgres    false    218   Xh       �          0    27512    personl_info 
   TABLE DATA           A   COPY public.personl_info (id, created_at, name, age) FROM stdin;
    public          postgres    false    233   �i       ~          0    27446    roles 
   TABLE DATA           2   COPY public.roles (name, permissions) FROM stdin;
    public          postgres    false    221   �i       �          0    27466    school_form 
   TABLE DATA           ;   COPY public.school_form (id, created_at, name) FROM stdin;
    public          postgres    false    225   �i       �          0    27474    student_form 
   TABLE DATA           G   COPY public.student_form (id, created_at, name, parent_id) FROM stdin;
    public          postgres    false    227   rj       �          0    27487    teacher_form 
   TABLE DATA           G   COPY public.teacher_form (id, created_at, name, parent_id) FROM stdin;
    public          postgres    false    229   &k       y          0    27395    users 
   TABLE DATA           q   COPY public.users (id, username, password_hash, role, created_at, email, phone, otp, otp_expires_at) FROM stdin;
    public          postgres    false    216   �k       �           0    0    child_relationships_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.child_relationships_id_seq', 5, true);
          public          postgres    false    222            �           0    0    company_form_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.company_form_id_seq', 1, false);
          public          postgres    false    230            �           0    0    form_permissions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.form_permissions_id_seq', 5, true);
          public          postgres    false    219            �           0    0    forms_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.forms_id_seq', 5, true);
          public          postgres    false    217            �           0    0    personl_info_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.personl_info_id_seq', 1, false);
          public          postgres    false    232            �           0    0    school_form_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.school_form_id_seq', 11, true);
          public          postgres    false    224            �           0    0    student_form_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.student_form_id_seq', 15, true);
          public          postgres    false    226            �           0    0    teacher_form_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.teacher_form_id_seq', 10, true);
          public          postgres    false    228            �           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 4, true);
          public          postgres    false    215            �           2606    27462 ,   child_relationships child_relationships_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.child_relationships
    ADD CONSTRAINT child_relationships_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.child_relationships DROP CONSTRAINT child_relationships_pkey;
       public            postgres    false    223            �           2606    27510    company_form company_form_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.company_form
    ADD CONSTRAINT company_form_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.company_form DROP CONSTRAINT company_form_pkey;
       public            postgres    false    231            �           2606    27435 5   form_permissions form_permissions_form_id_user_id_key 
   CONSTRAINT     |   ALTER TABLE ONLY public.form_permissions
    ADD CONSTRAINT form_permissions_form_id_user_id_key UNIQUE (form_id, user_id);
 _   ALTER TABLE ONLY public.form_permissions DROP CONSTRAINT form_permissions_form_id_user_id_key;
       public            postgres    false    220    220            �           2606    27433 &   form_permissions form_permissions_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.form_permissions
    ADD CONSTRAINT form_permissions_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.form_permissions DROP CONSTRAINT form_permissions_pkey;
       public            postgres    false    220            �           2606    27418    forms forms_form_name_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.forms
    ADD CONSTRAINT forms_form_name_key UNIQUE (form_name);
 C   ALTER TABLE ONLY public.forms DROP CONSTRAINT forms_form_name_key;
       public            postgres    false    218            �           2606    27416    forms forms_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.forms
    ADD CONSTRAINT forms_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.forms DROP CONSTRAINT forms_pkey;
       public            postgres    false    218            �           2606    27464    forms forms_share_token_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.forms
    ADD CONSTRAINT forms_share_token_key UNIQUE (share_token);
 E   ALTER TABLE ONLY public.forms DROP CONSTRAINT forms_share_token_key;
       public            postgres    false    218            �           2606    27520    personl_info personl_info_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.personl_info
    ADD CONSTRAINT personl_info_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.personl_info DROP CONSTRAINT personl_info_pkey;
       public            postgres    false    233            �           2606    27452    roles roles_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (name);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    221            �           2606    27472    school_form school_form_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.school_form
    ADD CONSTRAINT school_form_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.school_form DROP CONSTRAINT school_form_pkey;
       public            postgres    false    225            �           2606    27480    student_form student_form_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.student_form
    ADD CONSTRAINT student_form_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.student_form DROP CONSTRAINT student_form_pkey;
       public            postgres    false    227            �           2606    27493    teacher_form teacher_form_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.teacher_form
    ADD CONSTRAINT teacher_form_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.teacher_form DROP CONSTRAINT teacher_form_pkey;
       public            postgres    false    229            �           2606    27500    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    216            �           2606    27502    users users_phone_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_phone_key;
       public            postgres    false    216            �           2606    27403    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    216            �           2606    27405    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public            postgres    false    216            �           2606    27521 /   company_form fk_company_form_parent_school_form    FK CONSTRAINT     �   ALTER TABLE ONLY public.company_form
    ADD CONSTRAINT fk_company_form_parent_school_form FOREIGN KEY (parent_id) REFERENCES public.school_form(id) ON DELETE SET NULL;
 Y   ALTER TABLE ONLY public.company_form DROP CONSTRAINT fk_company_form_parent_school_form;
       public          postgres    false    225    231    4826            �           2606    27481 /   student_form fk_student_form_parent_school_form    FK CONSTRAINT     �   ALTER TABLE ONLY public.student_form
    ADD CONSTRAINT fk_student_form_parent_school_form FOREIGN KEY (parent_id) REFERENCES public.school_form(id) ON DELETE SET NULL;
 Y   ALTER TABLE ONLY public.student_form DROP CONSTRAINT fk_student_form_parent_school_form;
       public          postgres    false    227    225    4826            �           2606    27494 /   teacher_form fk_teacher_form_parent_school_form    FK CONSTRAINT     �   ALTER TABLE ONLY public.teacher_form
    ADD CONSTRAINT fk_teacher_form_parent_school_form FOREIGN KEY (parent_id) REFERENCES public.school_form(id) ON DELETE SET NULL;
 Y   ALTER TABLE ONLY public.teacher_form DROP CONSTRAINT fk_teacher_form_parent_school_form;
       public          postgres    false    229    4826    225            �           2606    27436 .   form_permissions form_permissions_form_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.form_permissions
    ADD CONSTRAINT form_permissions_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.forms(id);
 X   ALTER TABLE ONLY public.form_permissions DROP CONSTRAINT form_permissions_form_id_fkey;
       public          postgres    false    218    4814    220            �           2606    27441 .   form_permissions form_permissions_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.form_permissions
    ADD CONSTRAINT form_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 X   ALTER TABLE ONLY public.form_permissions DROP CONSTRAINT form_permissions_user_id_fkey;
       public          postgres    false    216    4808    220            �           2606    27419    forms forms_created_by_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.forms
    ADD CONSTRAINT forms_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);
 E   ALTER TABLE ONLY public.forms DROP CONSTRAINT forms_created_by_fkey;
       public          postgres    false    218    4808    216            �   �   x��ϱ
�0��9�}��任$���椣�؂Z���7��P!�����y�~y��}�s�s�N��T>[�f|]s1p������sv�l���R`v��BD�������?%u�e�
ې���d�H� K���
i�e��RC|�hT�h���[�      �      x������ � �      }   (   x�3�4��2�4���9��lN8۔�Ύ���� {{      {      x���Mk1���_�ԂY&�L�n"���h�zH6�tW�=H���z[a`�a���l���;���g�_u����_��ק��w~�.f������k��$�
i�� ! 6@ޒC��P��r���6��_'�s�v���RA��K�c�OO�e����M�\�Ѝ��JC�S
e��� Jh�^x@+���2���B�<}�ҝn�r�\�	��14xE����Et
���Er^	��h�����b�%��r���4�3�Ȏ����ɑ�C@)	��Ι4h�|�f�r�j����n�E      �      x������ � �      ~   D   x�KL����N.JM,I�IM�,�II�I��2S��srtAJj�@r�E�JAjj�@d*P���� ��m      �   i   x�m�;�0E��^�l �~q>N-RDD���1C����^yѺX��Gw�VQ�\'�P%���}�˛d��^i+�xϹC�w@q�fo�Lꉎ9�f�D�!      �   �   x�m�K
�0����@C�I�+�"v�M���E�n�ۛ�R��C�<����E��gD�US�Еa(@F���EN�R�T��=bv���p,Ӽ��Tr�r�ʲ)ګ�:�H]U3���_�,R����h��n�b[`��Jf��N9I�ܴ�q}���������;�      �   w   x�m�1�0 ��y�e;�����%H�D�0u��Db���D���q%^Y���.ǣ�'XHT�X2��V��e�EO�<Ի��<��H�Y�{�/��4�D�&�lǭ�`W!|��(�      y   W  x���OK�1��o?�z�d�$�yO"ă,� +^��D��Z����a� �L�a~��և��(��e`�x���L<��d���՟���u�o�?�g���^?L�6������O��PR��˟Tp#���m��.Г��E�ep$bJ��
TS�h1� ���D�sԘ!��[V����JpP'��6B�5L�I�U��b��q��a����Z��:������zuq}X�R���B0�rE���D���A;�QEQ���^9c��)��iG4U4f����4"K�{/h`֓Àwk�j	��.�f
���hz�Dy����6 ��o��q�v���w��b��%�T     