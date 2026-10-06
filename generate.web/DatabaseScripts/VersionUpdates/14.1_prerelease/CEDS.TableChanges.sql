-- Update the CEDS option set mapping for Accessibility Feature 
delete 
from ceds.CedsOptionSetMapping
where CedsElementTechnicalName = 'accessibilityfeaturetype';

insert into ceds.CedsOptionSetMapping (
	[CedsElementName]
	,[CedsElementTechnicalName]
	,[CedsGlobalId]
	,[CedsOptionSetCode]
	,[CedsOptionSetDescription]
	,[CedsOptionSetDefinition]
	,[EdFactsElementName]
	,[EdFactsOptionSetCode]
)
values 
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1000','Adaptive and specialized equipment or furniture','Furniture or equipment used to address physical or sensory needs.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1001','Adaptive calculator','A specialized calculator designed to accommodate users with diverse needs, such as visual impairments or motor difficulties, by customizing its interface and functionality to enhance accessibility and usability.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1002','Alternate response option','An alternate method for providing a response.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1003','Alternative text','Scripted statements describing graphics and images (e.g., tables, charts, graphs, timelines, photos, and illustrations).',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1004','Amplification','The ability to adjust the volume control beyond standard volume using other non-embedded devices including, but not limited to, assistive technology, personal hearing aids, or FM systems',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1005','Auditory calming','The use of auditory stimuli to promote relaxation and reduce stress or anxiety.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1006','Bilingual dictionary','A comprehensive dictionary containing definitions and contextual information in two languages that may contain construct-relevant terms.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1007','Word to word bilingual dictionary','A comprehensive collection of individual words or short phrases translated in two languages that may contain construct-relevant terms.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1008','Word to word bilingual glossary','A collection of construct-irrelevant individual words or short phrases translated in two languages.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1009','Braille','Braille code is a tactile system of raised dots that enables a person to read through touch.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1010','Breaks','A pause allowing the individual to temporarily suspend activities.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1011','Calculator','An electronic device or software that performs mathematical calculations.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1012','Closed captioning','Text-based transcriptions of dialogue, sounds, and relevant audio cues that are synchronized with a video or audio content.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1013','Reference sheet','A structured document specifically designed for providing reference materials, such as multiplication tables, periodic tables, etc.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1014','Assessment countdown timer','A timer which shows the time allowed for the assessment and counts down when the administration starts.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1015','English dictionary','A comprehensive dictionary containing definitions and contextual information in English that may contain construct-relevant terms.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1016','English glossary','A collection of grade and context appropriate definitions of specific construct-irrelevant terms in English.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1017','Assessment extended time','Additional time to complete an assessment beyond the standard time allotment.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1018','Highlighter','A tool for marking desired text.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1019','Illustration glossaries','A collection of key terms, concepts, or subjects accompanied by illustrative visuals, such as images, diagrams, or graphics. It is designed to enhance understanding and learning by combining written definitions with visual representations, making complex or abstract ideas more accessible and engaging.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1020','Large print paper assessment booklet','A larger size version of a paper- based assessment that increases the font size, illustrations, and other test elements.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1021','Line guide','A tool used to emphasize a line of text.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1022','Masking','A tool used to cover the text above and below the line or lines that the individual is reading, so that only one line or lines of text is visible at a time.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1023','Medical supports','Support for a person with a medical condition.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1024','Assessment multiple days','Assessment activities are completed over multiple days without extending the time available to complete the assessment.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1025','Noise canceling','Equipment used to block external sounds and reduce distractions.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1026','Group size','An adjustment to the number of individuals in the setting.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1027','Read aloud','Text is read aloud to the individual.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1028','Read aloud to self','The individual may read content aloud to themselves, with or without a device.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1029','Assessment Refocus','Redirecting the individual s focus during the assessment ensuring that such redirections do not suggest revisiting a prior item or imply potential errors.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1030','Repeat test directions','The individual being assessed may request that the test administrator repeat test directions prior to beginning the actual test items.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1031','Screen reader','A technology tool that describes what is being displayed on the screen (e.g., text, images), converting the content into audio or braille output.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1032','Setting','An adjustment in the environment based on individual needs.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1033','Signed administration','Content is presented via a form of sign language.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1034','Simplified test directions','Test directions, provided prior to beginning the test, are simplified or clarified.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1035','Speci?c test administrator','A designated test administrator.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1036','Display Format Adjustment','Content is presented in a streamlined, stacked, or simplified format.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1037','Strikethrough','A tool to visually mark or cancel out text.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1038','Tactile graphics','Tactile graphics convey non-textual information through touch. These may include tactile representations of pictures, maps, graphs, diagrams and other images.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1039','Tactile symbols','A static communication form that conveys concepts through touch, tactile symbols serve as supplementary elements to assessment or instruction content.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1040','Thesaurus','A thesaurus contains synonyms of words.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1041','Assessment time of day','Altering the schedule for administering assessments to the time of day optimal for the individual s needs.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1042','Translation','Converting text or speech from one language into another.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1043','Bilingual glossary','A collection of grade and context appropriate definitions of specific construct-irrelevant terms provided in two languages.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1044','Turn off any universal tools','Deactivating one or more universal tools the individual does not require, is unable to use, or could potentially cause distraction.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1045','Unlimited replays','The individual is allowed to replay multimedia components an unlimited number of times.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','1046','Unlimited rerecording','The individual is allowed to re-record responses an unlimited number of times.',NULL,'MISSING'),
('Accessibility Feature Type', 'AccessibilityFeatureType', '000385','9999','Other','The type of design elements or functionalities integrated into products, services, or environments to ensure equitable access for all individuals, aiming to eliminate barriers and facilitate ease of use is an option not yet defined in CEDS.',NULL,'MISSING')

delete 
from ceds.CedsOptionSetMapping
where CedsElementTechnicalName = 'AccessibilityFormatType';

insert into ceds.CedsOptionSetMapping (
	[CedsElementName]
	,[CedsElementTechnicalName]
	,[CedsGlobalId]
	,[CedsOptionSetCode]
	,[CedsOptionSetDescription]
	,[CedsOptionSetDefinition]
	,[EdFactsElementName]
	,[EdFactsOptionSetCode]
)
values 
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1000','Audio', 'Audio format is human-recorded or synthetic voice narration to present information. Audio can be stored and transmitted through both analog and digital means.',NULL,'MISSING'),
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1001','Audio Described Video', 'Audio description is the verbal explanation of essential visual elements in a video or other multimedia resource, providing access to the visual content when the audio component alone is insufficient for perceiving on-screen actions. (Note: While video is not covered by Section 121/Chafee Amendment of the Copyright Act, it is a material that can be enhanced for accessibility for use by students with disabilities.)',NULL,'MISSING'),
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1002','Braille', 'Braille code is a tactile system of raised dots that enables students who are blind or have low vision to read through touch. Braille consists of patterns of raised dots arranged in cells of up to six dots in a 3x2 configuration. Each cell represents letters of the alphabet, punctuation, numbers, and whole words. (iii) In the case of a child who is blind or visually impaired, provide for instruction in Braille and the use of Braille unless the IEP Team determines, after an evaluation of the childs reading and writing skills, needs, and appropriate reading and writing media (including an evaluation of the childs future needs for instruction in Braille or the use of Braille), that instruction in Braille or the use of Braille is not appropriate for the child; Sec. 300.324 (a) (2) (iii)',NULL,'MISSING'),
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1003','Captioned Video', 'Captions are the text representation of the audio content in a video or other multimedia production. Captions are synced with the video and include the words spoken, as well as other important information in the audio track. (Note: While video is not covered by Section 121/Chafee Amendment of the Copyright Act, it is a material that can be enhanced for accessibility for use by students with disabilities.)',NULL,'MISSING'),
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1004','Digital Text', 'Digital text format refers to accessible file formats that contain both text and images. An accessible digital text file must be usable by the student requiring this format. Examples of file types include accessible EPUB, HTML, MathML, and tagged PDF.',NULL,'MISSING'),
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1005','Large Print', 'Large print format is provided in a hard copy document containing a font size of 18 points or larger. Additional formatting considerations pertain to styles used for font face and punctuation; format options; use of color; paper selection; and document size.',NULL,'MISSING'),
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1006','Tactile Graphics', 'Tactile graphics convey non-textual information to people who are blind or have low vision. These may include tactile representations of pictures, maps, graphs, diagrams and other images. Students who are blind or have low vision can feel these raised lines and surfaces to access the same information as students who are sighted. (Note: While graphics are not covered by Section 121/Chafee Amendment of the Copyright Act, it is a material that can be enhanced for accessibility for use by students with disabilities.)',NULL,'MISSING'),
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1007','Text Transcripts of Audio','Transcripts are a text version of the speech and non-speech audio information needed to understand the content in an audio-only file. (Note: While audio is not covered by Section 121/Chafee Amendment of the Copyright Act, it is a material that can be enhanced for accessibility for use by students with disabilities.)',NULL,'MISSING'),
('Accessibility Format Type', 'AccessibilityFormatType', '002089','1008','Video with Synchronized American Sign Language (ASL)','Synchronized ASL is pre-produced sign language interpretation of audio content in a video or other multimedia resource. ASL is synchronized with and displayed alongside media, integrated into the media (picture-in-picture), displayed in a separate window, or displayed on a second screen. (Note: While audio is not covered by Section 121/Chafee Amendment of the Copyright Act, it is a material that can be enhanced for accessibility for use by students with disabilities.)',NULL,'MISSING')

print 'CEDS.TableChanges.sql executed for 14.1.'

