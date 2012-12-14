#region Source file version
// $Archive: /CLR.root/CLR/Text/TextRecordParser.cs $
// $Date: 12/18/06 15:48 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: TextRecordParser.cs $
// $Modtime: 9/28/06 14:31 $
#endregion
        
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Security;
using System.Security.Principal;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.SqlServer.Server;

namespace Dreamdb.ETL.Text
{
  /// <summary>
  /// Provides parsing capabilities supporting enumeration and / or forward readonly access to
  /// TextRecord objects contained in a source text. The source text is to be provided in form
  /// of a ready text stream or one or more filenames.
  /// </summary>
  public class TextRecordParser : IDisposable, IEnumerable<TextRecord>, IEnumerator<TextRecord>
  {

    #region Private Fields
    private TextRecordFormat m_format;
    private bool m_executing = false;
    private bool m_atheader = true;
    private LinkedList<FileInfo> m_files;
    private LinkedListNode<FileInfo> m_file;
    private StreamReader m_reader;
    private Match m_headermatch;
    private Match m_recordmatch;
    private TextRecord m_record;
    #endregion
    
    #region Constructors
    /// <summary>
    /// Construct a TextRecordParser for the default text record format.
    /// </summary>
    public TextRecordParser()
      : this(new TextRecordFormat()) { }

    /// <summary>
    /// Construct a TextRecordParser for a specific text record format providing options for exception behaviour.
    /// </summary>
    /// <param name="format">A TextRecordFormat to parse against.</param>
    /// <param name="options">A ParseErrorOptions value, individual options may be combined using bitwise or.</param>
    public TextRecordParser(TextRecordFormat format)
    {
      m_format = format;
      m_record = new TextRecord(m_format);
    }
    #endregion

    #region Properties


    /// <summary>
    /// Gets the TextRecordFormat that the TextRecordParser will execute against (as passed in the cconstructor).
    /// </summary>
    public TextRecordFormat Format
    {
      get { return m_format; }
    }

    /// <summary>
    /// Gets a value indicating if the current TextRecordParser is ready for execution.
    /// </summary>
    /// <returns>true if the the TextRecordParser is not currently executing and input has been specified, false otherwise.</returns>
    public bool IsReady
    {
      get { return !m_executing && (m_reader != null || m_files != null); }
    }

    /// <summary>
    /// Gets a value indicating if the TextRecordParser is currently executing.
    /// </summary>
    public bool IsExecuting
    {
      get { return m_executing; }
    }
    #endregion

    #region Input methods
    /// <summary>
    /// Call to set a StreamReader as parser input.
    /// </summary>
    /// <param name="reader">An open StreamReader to read input text from.</param>
    /// <exception cref="InvalidOperationException">Thrown if the parser is executing.</exception>
    public void SetInput(StreamReader reader)
    {
      if (m_executing)
      {
        throw new InvalidOperationException("The parser is currently executing.");
      }
      m_reader = reader;
    }

    /// <summary>
    /// Call to set the text contained in a file to be the parser input.
    /// </summary>
    /// <param name="filename">A qualified file name.</param>
    /// <exception cref="InvalidOperationException">Thrown if the parser is executing.</exception>
    public void SetInput(string filename)
    {
      if (m_executing)
      {
        throw new InvalidOperationException("The parser is currently executing");
      }
      string[] names = { filename };
      SetInput(names);
    }

    /// <summary>
    /// Call to set the text contained in a file to be the parser input.
    /// </summary>
    /// <param name="filenames">An array of qualified file names.</param>
    /// <exception cref="InvalidOperationException">Thrown if the parser is executing.</exception>
    public void SetInput(string[] filenames)
    {
      if (m_executing)
      {
        throw new InvalidOperationException("The parser is currently executing");
      }
      m_files = new LinkedList<FileInfo>();
      if (!SqlContext.IsAvailable)
      {
        foreach (string fn in filenames)
        {
          if (File.Exists(fn))
          {
            m_files.AddLast(new FileInfo(fn));
          }
        }
      }
      else
      {
        using (WindowsIdentity wi = SqlContext.WindowsIdentity)
        {
          WindowsImpersonationContext wic = wi.Impersonate();
          foreach (string fn in filenames)
          {
            if (File.Exists(fn))
            {
              m_files.AddLast(new FileInfo(fn));
            }
          }
          wic.Undo();
        }
      }
    }
    #endregion

    #region Invocation methods
    /// <summary>
    /// Execute the TextRecordParser.
    /// </summary>
    /// <returns>An enumerable collection of TextRecord objects.</returns>
    public IEnumerable<TextRecord> Execute()
    {
      if (!IsReady)
      {
        throw new InvalidOperationException("The TextRecordReader is not ready for execution.");
      }
      return this;
    }

    /// <summary>
    /// Execute the TextRecordParser against the text in a stream.
    /// </summary>
    /// <param name="reader">An open StreamReader containing the text input.</param>
    /// <returns>An enumerable collection of TextRecord objects.</returns>
    public IEnumerable<TextRecord> Execute(StreamReader reader)
    {
      if (!IsReady)
      {
        throw new InvalidOperationException("The TextRecordReader is not ready for execution.");
      }
      SetInput(reader);
      return this;
    }

    /// <summary>
    /// Execute the TextRecordParser against the text in a set of files.
    /// </summary>
    /// <param name="files">An array of (qualified) file names.</param>
    /// <returns>An enumerable collection of TextRecord objects.</returns>
    public IEnumerable<TextRecord> Execute(string[] files)
    {
      if (!IsReady)
      {
        throw new InvalidOperationException("The TextRecordReader is not ready for execution.");
      }
      SetInput(files);
      return this;
    }

    /// <summary>
    /// Execute the TextRecordParser.
    /// </summary>
    /// <returns>A TextRecordReader providing forward-only read-only access to the records in a text.</returns>
    public TextRecordReader ExecuteReader()
    {
      if (!IsReady)
      {
        throw new InvalidOperationException("The TextRecordReader is not ready for execution.");
      }
      return m_format.CreateReader(this);
    }

    /// <summary>
    /// Execute the TextRecordParser against the text in a stream.
    /// </summary>
    /// <param name="reader">An open StreamReader containing the text input.</param>
    /// <returns>A TextRecordReader providing forward-only read-only access to the records in the text.</returns>
    public TextRecordReader ExecuteReader(StreamReader reader)
    {
      m_reader = reader;
      return m_format.CreateReader(this);
    }

    /// <summary>
    /// Execute the TextRecordParser against the text in a set of files.
    /// </summary>
    /// <param name="files">An array of (qualified) file names.</param>
    /// <returns>A TextRecordReader providing forward-only read-only access to the records in the text.</returns>
    public TextRecordReader ExecuteReader(string[] files)
    {
      SetInput(files);
      return m_format.CreateReader(this);
    }
    #endregion

    #region Private Functions
    /// <summary>
    /// Advances the parser to the next record calling NextHeader() and NextFile().
    /// </summary>
    /// <returns>true if a record was found, false otherwise.</returns>
    private bool NextRecord()
    {

      if (m_atheader = m_atheader && m_format.HasHeader)
      {
        if (NextHeaderMatch())
        {
          Parse();
        }
        m_atheader = false;
      }

      if (NextRecordMatch())
      {
        Parse();
        return true;
      }
      else
      {
        if (NextFile())
        {
          m_atheader = true;
          return NextRecord();
        }
        else
        {
          Reset();
          return false;
        }
      }
    }

    /// <summary>
    /// Locates the next header match.
    /// </summary>
    /// <returns>true if a header was successfully matched, false otherwise</returns>
    private bool NextHeaderMatch()
    {
      string header = string.Empty;

      switch (m_format.HeaderLocation)
      {
        case HeaderLocation.FileName:
          header = (m_file != null) ? m_file.Value.Name : string.Empty;
          break;

        case HeaderLocation.FilePath:
          header = (m_file != null) ? m_file.Value.FullName : string.Empty;
          break;

        case HeaderLocation.SourceText:
          while (!m_reader.EndOfStream && !m_format.HeaderRegex.IsMatch(header))
          {
            if (m_format.HeaderRegex.Options == (m_format.HeaderRegex.Options & RegexOptions.Multiline))
            {
              header += m_reader.ReadLine();
            }
            else
            {
              header = m_reader.ReadLine();
            }
          }
          break;

        default:
          header = string.Empty;
          break;
      }

      m_headermatch = m_format.HeaderRegex.Match(header);
      return m_headermatch.Success;
    }

    /// <summary>
    /// Locates the next record match in the current stream.
    /// </summary>
    /// <returns>true if a record was successfully matched, false otherwise.</returns>
    private bool NextRecordMatch()
    {

      if (m_format.RecordRegex.Options == (m_format.RecordRegex.Options & RegexOptions.Multiline))
      {
        // We are reading the entire text directly from the match object
        if (m_recordmatch == null || !m_recordmatch.Success)
        {
          string text = m_reader.ReadToEnd();
          m_reader.Close();
          m_recordmatch = m_format.RecordRegex.Match(text);
          return m_recordmatch.Success;
        }
        else
        {
          m_recordmatch = m_recordmatch.NextMatch();
          return m_recordmatch.Success;
        }
      }
      else
      {
        // We are parsing text one line at a time (to support HUGE files)
        string text = string.Empty;
        while (!(m_reader.EndOfStream || (m_recordmatch = m_format.RecordRegex.Match(text)).Success))
        {
          text = m_reader.ReadLine();
        }
        if (m_reader.EndOfStream)
        {
          m_reader.Close();
        }
        return m_recordmatch.Success;
      }
    }

    /// <summary>
    /// Opens the next file for read into the private StreamReader.
    /// </summary>
    /// <returns>true if a file was opened, false otherwise.</returns>
    private bool NextFile()
    {

      if (m_files == null || m_file == m_files.Last)
      {
        return false;
      }
      m_file = (m_file == null) ? m_files.First : m_file.Next;
      FileInfo file = m_file.Value;
      if (!SqlContext.IsAvailable)
      {
        m_reader = file.OpenText();
      }
      else
      {
        using (WindowsIdentity wi = SqlContext.WindowsIdentity)
        {
          WindowsImpersonationContext wic = wi.Impersonate();
          m_reader = file.OpenText();
          wic.Undo();
        }
      }
      return true;
    }

    /// <summary>
    /// Parses the values of a match into appropriate fields of the current TextRecord. May throw exceptions.
    /// </summary>
    private void Parse()
    {
      string[] fns;
      Match m;
      if (m_atheader)
      {
        m_record = new TextRecord(m_format);
        fns = m_format.GetHeaderFieldNames();
        m = m_headermatch;
      }
      else
      {
        fns = m_format.GetRecordFieldNames();
        m = m_recordmatch;
      }

      foreach (string fn in fns)
      {
        Group g = m.Groups[fn];
        int i = m_format.Fields.IndexOf(fn);
        TextRecordField f = m_format.Fields[i];

        if (g.Success)
        {
          m_record[i] = g.Value;
        }

        else if (!(f.Default == null))
        {
          m_record[i] = f.Default;
        }

        else if (f.AllowDBNull)
        {
          m_record[i] = null;
        }
        else
        {
          m_record[i] = string.Empty;
        }
      }
      m_atheader = false;
    }
    #endregion

    #region IDisposable (implicit)
    public void Dispose()
    {
      Reset();
      m_files = null;
      m_record = null;
    }
    #endregion

    #region IEnumerable<TextRecord> (implicit implementation)
    /// <summary>
    /// Returns an enumerator for iterating through the TextRecord objects found by the parser.
    /// </summary>
    /// <returns>A IEnumerator for iterating through the TextRecord objects found by the parser.</returns>
    /// <exception cref="InvalidOperationException">The TextRecordParser was not ready for execution.</exception>
    public IEnumerator<TextRecord> GetEnumerator()
    {
      if (!IsReady)
      {
        throw new InvalidOperationException("The TextRecordParser is not ready for execution.");
      }
      return (IEnumerator<TextRecord>)this;
    }
    #endregion

    #region IEnumerator<TextRecord> (implicit implementation)
    /// <summary>
    /// Gets the current TextRecord object (null if the parser is not executing).
    /// </summary>
    public TextRecord Current
    {
      get
      {
        if (IsExecuting)
        {
          return m_record;
        }
        return null;
      }
    }
    
    /// <summary>
    /// Call to reset the parser state for execution.
    /// </summary>
    /// <remarks>A TextRecordParser invoked on a StreamReader will not be ready until input(s) are set.</remarks>
    public void Reset()
    {
      m_atheader = true;
      m_executing = false;
      m_file = null;
      if (m_reader != null)
      {
        m_reader.Close();
        m_reader = null;
      }
    }

    /// <summary>
    /// Advances the parser to the next record in the input text.
    /// </summary>
    /// <returns>True if a record is found, false otherwise.</returns>
    public bool MoveNext()
    {
      if (m_executing)
      {
        return NextRecord();
      }
      else
      {
        if (!IsReady)
        {
          throw new InvalidOperationException("No input is currently specified for the TextRecordParser.");
        }
        else
        {
          m_executing = true;
          if (m_reader == null)
          {
            return NextFile() && NextRecord();
          }
          else
          {
            return NextRecord();
          }
        }
      }
    }
    #endregion

    #region IEnumerable (explicit implementation)
    IEnumerator IEnumerable.GetEnumerator()
    {
      if (!IsReady)
      {
        throw new InvalidOperationException("The TextRecordParser is not ready for execution.");
      }
      return (IEnumerator)this;
    }
    #endregion

    #region IEnumerator (explicit implementaion)
    /// <summary>
    /// Gets the current TextRecord object (null if the parser is not executing).
    /// </summary>
    object IEnumerator.Current
    {
      get { return Current; }
    }

    /// <summary>
    /// Advances the parser to the next record in the input text.
    /// </summary>
    /// <returns>True if a record is found, false otherwise.</returns>
    bool IEnumerator.MoveNext()
    {
      return MoveNext();
    }

    /// <summary>
    /// Call to reset the parser state for execution.
    /// </summary>
    /// <remarks>A TextRecordParser invoked on a StreamReader will not be ready until input(s) are set.</remarks>
    void IEnumerator.Reset()
    {
      Reset();
    }
    #endregion
  }
}