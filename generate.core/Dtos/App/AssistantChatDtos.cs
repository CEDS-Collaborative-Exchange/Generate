namespace generate.core.Dtos.App
{
    /// <summary>Create-session payload for the general assistant chat.</summary>
    public class AssistantSessionCreateDto
    {
        public string Title { get; set; }
        public string CreatedBy { get; set; }
    }

    /// <summary>A user chat turn in the general assistant.</summary>
    public class AssistantUserMessageDto
    {
        public string Content { get; set; }
        public string CreatedBy { get; set; }
    }
}
