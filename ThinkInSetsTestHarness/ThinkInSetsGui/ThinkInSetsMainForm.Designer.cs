namespace ThinkInSetsGui
{
    partial class ThinkInSetsMainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.currentTestLabel = new System.Windows.Forms.Label();
            this.currentTestTestBox = new System.Windows.Forms.TextBox();
            this.changeTestButton = new System.Windows.Forms.Button();
            this.startButton = new System.Windows.Forms.Button();
            this.cancelButton = new System.Windows.Forms.Button();
            this.resultsLabel = new System.Windows.Forms.Label();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // currentTestLabel
            // 
            this.currentTestLabel.AutoSize = true;
            this.currentTestLabel.Location = new System.Drawing.Point(13, 13);
            this.currentTestLabel.Name = "currentTestLabel";
            this.currentTestLabel.Size = new System.Drawing.Size(61, 13);
            this.currentTestLabel.TabIndex = 0;
            this.currentTestLabel.Text = "Current test";
            // 
            // currentTestTestBox
            // 
            this.currentTestTestBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.currentTestTestBox.Location = new System.Drawing.Point(80, 10);
            this.currentTestTestBox.Name = "currentTestTestBox";
            this.currentTestTestBox.ReadOnly = true;
            this.currentTestTestBox.Size = new System.Drawing.Size(356, 20);
            this.currentTestTestBox.TabIndex = 1;
            // 
            // changeTestButton
            // 
            this.changeTestButton.Location = new System.Drawing.Point(57, 39);
            this.changeTestButton.Name = "changeTestButton";
            this.changeTestButton.Size = new System.Drawing.Size(123, 23);
            this.changeTestButton.TabIndex = 2;
            this.changeTestButton.Text = "Change Test ...";
            this.changeTestButton.UseVisualStyleBackColor = true;
            // 
            // startButton
            // 
            this.startButton.Enabled = false;
            this.startButton.Location = new System.Drawing.Point(187, 40);
            this.startButton.Name = "startButton";
            this.startButton.Size = new System.Drawing.Size(75, 23);
            this.startButton.TabIndex = 3;
            this.startButton.Text = "Start";
            this.startButton.UseVisualStyleBackColor = true;
            // 
            // cancelButton
            // 
            this.cancelButton.Enabled = false;
            this.cancelButton.Location = new System.Drawing.Point(268, 40);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(75, 23);
            this.cancelButton.TabIndex = 4;
            this.cancelButton.Text = "Cancel";
            this.cancelButton.UseVisualStyleBackColor = true;
            // 
            // resultsLabel
            // 
            this.resultsLabel.AutoSize = true;
            this.resultsLabel.Location = new System.Drawing.Point(16, 83);
            this.resultsLabel.Name = "resultsLabel";
            this.resultsLabel.Size = new System.Drawing.Size(42, 13);
            this.resultsLabel.TabIndex = 5;
            this.resultsLabel.Text = "Results";
            // 
            // dataGridView1
            // 
            this.dataGridView1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(19, 113);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(417, 177);
            this.dataGridView1.TabIndex = 6;
            // 
            // ThinkInSetsMainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(460, 311);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.resultsLabel);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.startButton);
            this.Controls.Add(this.changeTestButton);
            this.Controls.Add(this.currentTestTestBox);
            this.Controls.Add(this.currentTestLabel);
            this.MinimumSize = new System.Drawing.Size(400, 350);
            this.Name = "ThinkInSetsMainForm";
            this.Text = "Think in Sets Test Harness";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label currentTestLabel;
        private System.Windows.Forms.TextBox currentTestTestBox;
        private System.Windows.Forms.Button changeTestButton;
        private System.Windows.Forms.Button startButton;
        private System.Windows.Forms.Button cancelButton;
        private System.Windows.Forms.Label resultsLabel;
        private System.Windows.Forms.DataGridView dataGridView1;
    }
}

