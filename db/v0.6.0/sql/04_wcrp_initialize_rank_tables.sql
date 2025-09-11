CREATE SCHEMA IF NOT EXISTS wcrp_bela_atna_necl;
CREATE SCHEMA IF NOT EXISTS wcrp_bowr_ques_carr;
CREATE SCHEMA IF NOT EXISTS wcrp_bulk;
CREATE SCHEMA IF NOT EXISTS wcrp_elkr;
CREATE SCHEMA IF NOT EXISTS wcrp_hors;
CREATE SCHEMA IF NOT EXISTS wcrp_lnic;
CREATE SCHEMA IF NOT EXISTS wcrp_morr;
CREATE SCHEMA IF NOT EXISTS wcrp_tho_shu;
CREATE SCHEMA IF NOT EXISTS wcrp_tuzistol_tah;


SELECT bcfishpass.create_rank_table('wcrp_bela_atna_necl','bela_atna_necl');
SELECT bcfishpass.create_rank_table('wcrp_bowr_ques_carr','bowr_ques_carr');
SELECT bcfishpass.create_rank_table('wcrp_bulk','bulk');
SELECT bcfishpass.create_rank_table('wcrp_elkr','elkr_dnstr');
SELECT bcfishpass.create_rank_table('wcrp_elkr','elkr_upstr');
SELECT bcfishpass.create_rank_table('wcrp_hors','hors');
SELECT bcfishpass.create_rank_table('wcrp_lnic','lnic');
SELECT bcfishpass.create_rank_table('wcrp_morr','morr');
SELECT bcfishpass.create_rank_table('wcrp_tho_shu','bonp');
SELECT bcfishpass.create_rank_table('wcrp_tho_shu','bessette');
SELECT bcfishpass.create_rank_table('wcrp_tho_shu','eagle');
SELECT bcfishpass.create_rank_table('wcrp_tuzistol_tah','tuzistol_tah');